if IsClient() then 
CreateThread(function()
	local elements = {}
	local Salle = {
		{label="Apple"},
		{type="slider",options={"apple","banana","orange"}}
	}
	for k,v in pairs(Salle) do
	   table.insert(elements,{
       label = v.label,
       pos  = v.pos,
	   type = v.type,
	   options = v.options
     })
	end
	
	NB.Menu.CloseAll()
	NB.Menu.Open(
		'default', GetCurrentResourceName(), 'strip',
		{
			title  = 'Position Menu',
			description = "WTF",
			elements = elements
		},
		function(data, menu)
			print("result open",json.encode(data))
			menu.close()
		end,
		function(data, menu)
			print("result close",json.encode(data))
			menu.close()
		end
		,
		function(data, menu)
			print("result change",json.encode(data))
			
		end
		,
		function()
			print("result close")
			
		end
	)
end)
end 