if IsClient() then 
--bridge
	NBMenu.RegisterPauseMenu = function(title,description,namespace,elements,onsubmit,oncancel,onchange,onclose)
		local menuHandle = NBMenu.RequestMenu(title,description,"PauseMenu",namespace)
		--NBMenu.UpdateMenuHeader(menuHandle,'1asda','zxcasd') 
		NBMenu.SetMenuButtons(menuHandle,{
			--[=[
			NBMenu.AddButton("apple5",123,"dd","rapple"),
			NBMenu.AddSlider("apple"..math.random(0,99),{
				{"apple","Red Color and taste good"},
				{"banana","Become Smart,Become Clever"},
				{"orange","Juicy and tasty"},
				{"lame"}
			}),
			--]=]
			NBMenu.AddElements(elements)
		}) 
		NBMenu.SetMenuCallbacks(menuHandle,{
			onsubmit,
			oncancel,
			onchange,
			onclose
		})
		NB.RegisterKeyEvent('test',function(input)
			local function GetPos() local a,b,c = GetPauseMenuSelectionData() return c ~= -1 and c+1 or 1 end 
			switch(input)(
				case("MENU_LEFT")(function()
						NBMenu.SetCurrentSlot(menuHandle,GetPos())
						print('left',NBMenu.IsCurrentSlotSlider(menuHandle),NBMenu.GetCurrentItemSlot(menuHandle) )
						if NBMenu.IsCurrentSlotSlider(menuHandle) then
							NBMenu.SetCurrentItemSlot(menuHandle,NBMenu.GetCurrentItemSlot(menuHandle)-1)
							NBMenu.TriggerMenuCallback(menuHandle,"Change")
						end 
				end),
				case("MENU_RIGHT")(function()
						NBMenu.SetCurrentSlot(menuHandle,GetPos())
						if NBMenu.IsCurrentSlotSlider(menuHandle) then
							NBMenu.SetCurrentItemSlot(menuHandle,NBMenu.GetCurrentItemSlot(menuHandle)+1)
							NBMenu.TriggerMenuCallback(menuHandle,"Change")
						end 
				end),
				case("MENU_UP")(function()
						NBMenu.SetCurrentSlot(menuHandle,GetPos())
						if NBMenu.IsCurrentSlotSlider(menuHandle) then
							NBMenu.TriggerMenuCallback(menuHandle,"Change")
						end 
				end),
				case("MENU_DOWN")(function()
						NBMenu.SetCurrentSlot(menuHandle,GetPos())
						if NBMenu.IsCurrentSlotSlider(menuHandle) then
							NBMenu.TriggerMenuCallback(menuHandle,"Change")
						end 
				end),
				case("MENU_ENTER","MENU_SELECT")(function()
						NBMenu.SetCurrentSlot(menuHandle,GetPos())
						NBMenu.TriggerMenuCallback(menuHandle,"Submit")
				end),
				case("MENU_BACK")(function()
						NBMenu.SetCurrentSlot(menuHandle,GetPos())
						NBMenu.TriggerMenuCallback(menuHandle,"Cancel")
				end),
				case("MENU_ESCAPE")(function()
						NBMenu.SetCurrentSlot(menuHandle,GetPos())
						NBMenu.TriggerMenuCallback(menuHandle,"Close")
				end),
				default(function()
				end)
			)
		end )
		PauseMenu.StartPauseMenu(PauseMenu.versionid.FE_MENU_VERSION_MP_CHARACTER_CREATION)
		return menuHandle
	end 

end 