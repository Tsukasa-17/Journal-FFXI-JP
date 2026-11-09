-- Original metadata stays parse-compatible; Japanese derivative credit lives here.
local M={version='0.3.0',name='Tsukasa'}
M.suffix='[jpver '..M.version..' by '..M.name..']'
M.author='Kxteel '..M.suffix
function M.display(version)return 'Journal '..tostring(version or '0.3.0')..' by '..M.author end
return M
