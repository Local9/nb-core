if IsClient() then 
	CreateThread(function()
		local Salle = {
			{label="Apple",value="Apple"},
			{label="选择水果",type="slider",options={
				{label="apple"},
				{label="banana"},
				{label="orange"}
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
		local menu = com.menu.ESXMenuFramework.Open(
			'PauseMenu', GetCurrentResourceName(), 'shop',
			{
			css =  'superete',
			title =  'Magasin',
			description = "Good",
			elements = Salle
			},
			function(data, menu)
				print('Submit')
			end,
			function(data, menu)
				menu.close()
				print('Close')
			end
		)
		NBMenu.SetCurrentSlot(menu.namespace,menu.name,2)
		print(NBMenu.GetCurrentSlot(menu.namespace,menu.name),NBMenu.IsCurrentSlotSlider(menu.namespace,menu.name))
		NBMenu.SetCurrentItemSlot(menu.namespace,menu.name,2)
		print(NBMenu.GetItemSlotPos(menu.namespace,menu.name,2))
		--menu.close()
		--NBMenu.SetMenuAsNoLongerNeeded(menuHandle)
		Wait(300)
		
	end)
end 