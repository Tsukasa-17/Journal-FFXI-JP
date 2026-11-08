-- Journal-only font preference/discovery. No atlas changes in settings frames.
local M = {}
local preference = 'meiryo'
local cache, cache_until, cache_root
local loaded = {requested='meiryo', actual='meiryo', status='default'}
local bundled = {'CarroisGothicSC-Regular.ttf','FiraSans-Bold.ttf','FiraSans-Italic.ttf','FiraSans-Regular.ttf','calibri.ttf','azukifontLP.ttf'}

function M.normalize(value)
    if value == nil or value == 'meiryo' then return 'meiryo' end
    if type(value) ~= 'string' then return 'meiryo' end
    local name = value:match('^assets/fonts/(.+)$')
    if not name or name:find('..',1,true) or name:find('[/\\:%z\1-\31<>"|?*#]')
        or not require('style_ja').valid_utf8(name) then return 'meiryo' end
    if name:match('[%. ]$') then return 'meiryo' end
    local stem=(name:match('^([^%.]+)') or ''):upper()
    if ({CON=true,PRN=true,AUX=true,NUL=true})[stem] or stem:match('^COM[1-9]$') or stem:match('^LPT[1-9]$') then return 'meiryo' end
    local ext = name:match('%.([^%.]+)$')
    if not ext or not ({ttf=true,otf=true,ttc=true})[ext:lower()] then return 'meiryo' end
    return 'assets/fonts/' .. name
end
-- Do not use the opacity step-rounder: valid saved79% must not become80%.
function M.clamp_scale(value, minimum, maximum, default)
    value=tonumber(value)
    if not value or value~=value or value==math.huge or value==-math.huge then return default end
    return math.max(minimum, math.min(maximum, value))
end
function M.get() return preference end
function M.load(value) preference=M.normalize(value);cache=nil end
function M.set(value)
    local code=M.normalize(value)
    if value ~= code then return false end
    if code==preference then return false end
    preference=code;cache=nil;return true
end
function M.meiryo_path(bold)
    return (os.getenv('WINDIR') or os.getenv('SystemRoot') or 'C:\\Windows')
        .. '\\Fonts\\' .. (bold and 'meiryob.ttc' or 'meiryo.ttc')
end
function M.path(addon, code)
    code=M.normalize(code)
    if code=='meiryo' then return M.meiryo_path() end
    return tostring(addon.path or ''):gsub('[/\\]+$','') .. '/' .. code
end
function M.exists(path)
    local status_ok, regular=pcall(function()
        local status=ashita.fs.status(path);return status and status.is_regular_file
    end)
    if status_ok and regular==false then return false end
    local ok,result=pcall(function() local f=io.open(path,'rb');if not f then return false end;f:close();return true end)
    return ok and result
end

-- Preflight SFNT/TTC headers/table bounds before the native parser sees a file.
-- Not a full font sanitizer; native load failures are also guarded by pcall.
function M.valid_font_file(path)
    local ok,result=pcall(function()
        local f=io.open(path,'rb');if not f then return false end
        local function check()
            local size=f:seek('end');if not size or size<12 or size>64*1024*1024 then return false end
            local function at(offset,n)if offset<0 or offset+n>size then return nil end;f:seek('set',offset);return f:read(n)end
            local function u16(s,p)local a,b=s:byte(p,p+1);return a and b and a*256+b end
            local function u32(s,p)local a,b,c,d=s:byte(p,p+3);return a and b and c and d and ((a*256+b)*256+c)*256+d end
            local offset=0;local head=at(0,12)
            if head:sub(1,4)=='ttcf' then
                local count=u32(head,9);if not count or count<1 or count>1024 then return false end
                local offsets=at(12,count*4);if not offsets then return false end
                offset=u32(offsets,1);head=at(offset,12);if not head then return false end
            end
            local tag=head:sub(1,4)
            if tag~='\0\1\0\0'and tag~='OTTO'and tag~='true'then return false end
            local count=u16(head,5);if not count or count<1 or count>2048 then return false end
            local records=at(offset+12,count*16);if not records or #records~=count*16 then return false end
            local cmap,outlines=false,false
            for n=1,count do
                local p=(n-1)*16+1;local name=records:sub(p,p+3)
                local start,length=u32(records,p+8),u32(records,p+12)
                if not start or not length or start+length>size then return false end
                cmap=cmap or name=='cmap';outlines=outlines or name=='glyf'or name=='CFF 'or name=='CFF2'
            end
            return cmap and outlines
        end
        local valid_ok,valid=pcall(check);f:close();return valid_ok and valid
    end)
    return ok and result
end

function M.choices(addon, force)
    local root=tostring(addon.path or ''):gsub('\\','/'):gsub('/+$','') .. '/assets/fonts/'
    if cache and cache_root==root and not force and os.clock()<cache_until then return cache end
    local list={{code='meiryo',label='Windows Meiryo',available=M.exists(M.meiryo_path())}}
    local ok,entries=pcall(function()return ashita.fs.get_directory(root,'*',false)end)
    local scan=ok and type(entries)=='table'
    if not scan then entries=bundled end
    local seen={meiryo=true}
    for _,value in pairs(entries) do
        if type(value)=='string' then
            local name=value:gsub('\\','/')
            if name:sub(1,#root):lower()==root:lower() then name=name:sub(#root+1) end
            if name:sub(1,13)=='assets/fonts/'then name=name:sub(14)end
            local code=M.normalize('assets/fonts/'..name)
            if code~='meiryo' and not seen[code] and M.exists(M.path(addon,code)) then
                seen[code]=true;list[#list+1]={code=code,label=name,available=true}
            end
        end
    end
    table.sort(list,function(a,b)if a.code==b.code then return false end;if a.code=='meiryo'then return true elseif b.code=='meiryo'then return false end;return a.label:lower()<b.label:lower()end)
    if not seen[preference] then list[#list+1]={code=preference,label=preference:match('[^/]+$')or preference,available=false}end
    list.scan_available=scan
    cache,cache_until,cache_root=list,os.clock()+5,root
    return list
end
function M.loaded(requested,actual,status) loaded={requested=requested,actual=actual,status=status} end
function M.status() return loaded end

function M.draw(imgui,addon,controller)
    local tx=require('i18n').t
    local choices=M.choices(addon);local current=controller.GetFontChoice();local preview=current
    for _,entry in ipairs(choices)do if entry.code==current then preview=tx(entry.label);if not entry.available then preview=preview..' '..tx('(unavailable)')end end end
    imgui.Text(tx('Font (50%-140% text size)'))
    if imgui.BeginCombo('##JournalFontChoice',preview) then
        for _,entry in ipairs(choices)do
            local label=tx(entry.label)..(entry.available and ''or' '..tx('(unavailable)'))
            if imgui.Selectable(label..'##JournalFont_'..entry.code,entry.code==current)then controller.SetFontChoice(entry.code)end
        end
        imgui.EndCombo()
    end
    imgui.TextWrapped(tx('Font changes require /addon reload journal.'))
    if current~='meiryo'then imgui.TextWrapped(tx('Selected fonts may lack Japanese glyphs. Choose Windows Meiryo if text is missing.'))end
    if not choices.scan_available then imgui.TextWrapped(tx('Font scanning unavailable; showing known bundled files only.'))end
    if loaded.status=='load-failed' or loaded.status=='meiryo-missing'then imgui.TextWrapped(tx('The requested font could not be loaded; a fallback font is active.'))end
end
return M
