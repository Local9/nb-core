LoadDataSheet = function(dataname,iskeys)
	local keys 
	NB.Datas[dataname],keys = com.lua.utils.Csv.LoadDataSheet(dataname,iskeys)
	--[=[
	for i,v in pairs(NB.Datas[dataname]) do 
		for k,c in pairs(v) do 
			print(k,c)
		end 
	end 
	--]=]
	return NB.Datas[dataname],keys
end 


LoadDataSheet("items",true)
LoadDataSheet("monster")
