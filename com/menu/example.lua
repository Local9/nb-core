if IsClient() then 
CreateThread(function()
	local elements = {}
	local Salle = {
		{label="Apple",pos=vector3(0.0,0.0,0.0)}
	}
	for k,v in pairs(Salle) do
	   table.insert(elements,{
       label = v.label,
       pos  = v.pos
     })
	end
	
	com.menu.framework.CloseAll()
	com.menu.framework.Open(
		'default', GetCurrentResourceName(), 'strip',
		{
			title  = 'Position Menu',
			description = "WTF",
			elements = elements
		},
		function(data, menu)
			print("result open",json.encode(data))
		end,
		function(data, menu)
			print("result close",json.encode(data))
			menu.close()

		end
	)
end)
end 