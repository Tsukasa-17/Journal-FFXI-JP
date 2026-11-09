-- Original metadata stays parse-compatible; Japanese derivative credit lives here.
local M={version='0.3.0',name='Tsukasa'}
M.suffix='[jpver '..M.version..' by '..M.name..']'
M.author='Kxteel '..M.suffix
M.contributor='hando'
M.contributor_line='協力者: hando（handomade）　ご協力ありがとうございます'
function M.display(version)return 'Journal '..tostring(version or '0.3.0')..' by '..M.author end
return M
