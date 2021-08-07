LoadDataSheet = function(dataname)
	NB.Datas[dataname] = com.lua.utils.Csv.LoadDataSheet(dataname,false)
	--[=[
	for i,v in pairs(NB.Datas[dataname]) do 
		for k,c in pairs(v) do 
			print(k,c)
		end 
	end 
	--]=]
end 


LoadDataSheet("items")
LoadDataSheet("monster")
