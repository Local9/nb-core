if IsClient() then 
	CreateThread(function()
		local menu2
		local Salle = {
			{label="Apple",value="Apple"},
			{label="选择水果",type="slider",options={
				{label="apple"},
				{label="banana"},
				{label="orange"}
			},description="select your favour"},
			{label="选择水果",type="slider",options={
				"apple","banana","orange"
			},description="select your favour"},
			{label="Apple123",value="Apple123",description="good health",setter="X"},
			{label="Apple123",value="Apple123",setter="XY"},
			{label="Apple123",value="Apple123"},
			{label="Apple123",value="Apple123"},
			{label="Apple123",value="Apple123"},
			{label="Apple123",value="Apple123"},
			{label="Apple123",value="Apple123"},
			{label="Apple123",value="Apple123"},
			{label="Apple1234",value="Apple1234"},
			{label="Apple123",value="Apple123",setter="XY"},
			{label="保存",value="Save",type="footer"},
		}
		local menu = com.menu.ESXMenu.Open(
			'default', GetCurrentResourceName(), 'shop',
			{--data
			css =  'superete',
			title =  'Magasin',
			description = "Good",
			elements = Salle
			},
			function(data, menu)
				print("Submit1")
				
				
			end,
			function(data, menu)
				menu.close()
				print('Cancel')
			end
			,
			function(data, menu)
				print('Change1')
			end
			,
			function()
				print('Close1')
			end
		)
		
		
	end)
end 