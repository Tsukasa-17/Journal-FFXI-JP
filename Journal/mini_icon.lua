-- Backgroundless Journal mini icon. Texture pixels/UVs recorded in image manifest.
local M={}
local size=96
local drag=nil
local next_texture_attempt=0
function M.clamp_size(v)
    v=tonumber(v)
    if not v or v~=v or v==math.huge or v==-math.huge then return 96 end
    return math.max(64,math.min(128,math.floor(v+.5)))
end
function M.load(v)size=M.clamp_size(v);drag=nil end
function M.get_size()return size end
function M.set_size(v)local n=M.clamp_size(v);if n==size then return false end;size=n;return true end
function M.cancel()drag=nil end
function M.retry_texture()
    if os.clock()<next_texture_attempt then return false end
    next_texture_attempt=os.clock()+5;return true
end
local function finite(v)return type(v)=='number'and v==v and v~=math.huge and v~=-math.huge end
function M.bounds(x,y,dw,dh)
    local h=size;local w=math.floor(h*856/1100+.5)
    if not finite(dw)or dw<=0 then dw=1920 end
    if not finite(dh)or dh<=0 then dh=1080 end
    if h>dh or w>dw then local ratio=math.min(dw/w,dh/h);w=math.max(1,math.floor(w*ratio));h=math.max(1,math.floor(h*ratio))end
    if not finite(x)then x=20 end;if not finite(y)then y=20 end
    return math.max(0,math.min(dw-w,x)),math.max(0,math.min(dh-h,y)),w,h
end
-- Captures a press on the image, opens only on release with <4px movement.
-- Persist once on release; crossing threshold remains a drag even if moved back.
function M.pointer(x,y,mx,my,down,clicked,hover,dw,dh)
    local opened,persist=false,false
    if clicked and hover and finite(mx)and finite(my)then drag={mx=mx,my=my,x=x,y=y,px=x,py=y,moved=false}end
    if drag then
        if finite(mx)and finite(my)then
            local dx,dy=mx-drag.mx,my-drag.my
            if dx*dx+dy*dy>=16 then drag.moved=true end
            if drag.moved then drag.px,drag.py=M.bounds(drag.x+dx,drag.y+dy,dw,dh)end
        end
        x,y=drag.px,drag.py
        if not down then opened=not drag.moved;persist=drag.moved;drag=nil end
    end
    return x,y,opened,persist
end
local function mouse(imgui)
    local ok,x,y=pcall(imgui.GetMousePos)
    if ok and type(x)~='number' then
        local vector=x
        local valid,px,py=pcall(function()return vector.x or vector[1],vector.y or vector[2]end)
        if valid then x,y=px,py end
    end
    if not ok then return nil,nil end
    return x,y
end
function M.draw(imgui,controller,state,texture)
    local tx=require('i18n').t
    local dw,dh=require('window_fit').get_display_size(imgui)
    local x,y,w,h=M.bounds(drag and drag.px or state.x,drag and drag.py or state.y,dw,dh)
    if not drag and(x~=state.x or y~=state.y)then controller.SetJournalMiniGeometry(x,y)end
    imgui.SetNextWindowPos({x,y});imgui.SetNextWindowSize({w,h})
    if imgui.SetNextWindowBgAlpha then imgui.SetNextWindowBgAlpha(0)end
    imgui.PushStyleVar(ImGuiStyleVar_WindowPadding,{0,0})
    imgui.PushStyleVar(ImGuiStyleVar_WindowBorderSize,0)
    imgui.PushStyleVar(ImGuiStyleVar_WindowRounding,0)
    local flags=ImGuiWindowFlags_NoTitleBar+ImGuiWindowFlags_NoResize+ImGuiWindowFlags_NoScrollbar+ImGuiWindowFlags_NoScrollWithMouse+ImGuiWindowFlags_NoCollapse+ImGuiWindowFlags_NoMove+(ImGuiWindowFlags_NoBackground or 128)
    local opened=false
    if imgui.Begin('Journal Mini###JournalMini',{true},flags)then
        imgui.SetCursorPos({0,0})
        if texture and imgui.Image then
            local ok=pcall(imgui.Image,texture,{w,h},{0,0},{856/1024,1100/2048},{1,1,1,1},{0,0,0,0})
            if not ok then imgui.Text(tx('Open'))end
        else imgui.Text(tx('Open'))end
        imgui.SetCursorPos({0,0})
        local pressed=imgui.InvisibleButton('##JournalMiniImage',{w,h})
        local hover=imgui.IsItemHovered()
        if imgui.GetMousePos and imgui.IsMouseDown and imgui.IsMouseClicked then
            local mx,my=mouse(imgui)
            local ok,down,clicked=pcall(function()return imgui.IsMouseDown(0),imgui.IsMouseClicked(0)end)
            if ok and finite(mx) and finite(my) then
                local nx,ny,persist
                nx,ny,opened,persist=M.pointer(x,y,mx,my,down,clicked,hover,dw,dh)
                if persist then controller.SetJournalMiniGeometry(nx,ny)end
            else opened=(not drag) and pressed;M.cancel()end
        else opened=(not drag) and pressed;M.cancel()end
        if hover and not drag and imgui.BeginTooltip then
            imgui.BeginTooltip();imgui.Text(tx('Click to open; drag to move.'));imgui.EndTooltip()
        end
    else M.cancel()end
    imgui.End();imgui.PopStyleVar(3)
    return opened
end
function M.settings(imgui,controller)
    local tx=require('i18n').t
    imgui.Text(tx('Closed icon size (64-128 px)'))
    if imgui.SliderInt then
        local box={controller.GetJournalMiniSize()}
        if imgui.SliderInt('##JournalMiniSize',box,64,128,'%d px')then controller.SetJournalMiniSize(box[1])end
    else
        if imgui.Button('-##JournalMiniSizeMinus')then controller.SetJournalMiniSize(controller.GetJournalMiniSize()-1)end
        imgui.SameLine();imgui.Text(tostring(controller.GetJournalMiniSize())..' px');imgui.SameLine()
        if imgui.Button('+##JournalMiniSizePlus')then controller.SetJournalMiniSize(controller.GetJournalMiniSize()+1)end
    end
    if imgui.Button(tx('Reset icon position')..'##JournalMiniReset')then controller.SetJournalMiniGeometry(20,20)end
end
return M
