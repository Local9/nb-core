NB = {Datas={},Players={},Utils={},Threads={}}  
function IsServer() return IsDuplicityVersion() end 
function IsClient() return not IsDuplicityVersion() end 
function IsShared() return true end
function Main (fn) return fn() end


































