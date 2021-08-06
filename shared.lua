NB = {}

NB.com = com 
NB.GetCSVDatas = com.lua.utils.Csv.GetDatas
NB.SetCSVDatas = com.lua.utils.Csv.SetDatas

exports('GetSharedObject', function()
	return NB
end)
