if IsClient() then 
CreateThread(function()
	local elements = {}
	local Salle = {
		{label="Apple",value="Apple"},
		{label="选择水果",type="slider",options={"apple","banana","orange"}}
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
		'PauseMenu', GetCurrentResourceName(), 'strip',
		{
			title  = 'Position Menu',
			description = "WTF",
			elements = elements
		},
		function(data, menu)
			print("result open",data.current.value)
			--menu.close()
		end,
		function(data, menu)
			print("result close",data.current.value)
			--menu.close()
		end
		,
		function(data, menu)
			print("result change",data.current.value)
			
		end
		,
		function()
			print("result close")
			
		end
	)
end)
end 