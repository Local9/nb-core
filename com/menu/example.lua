if IsClient() then 
	CreateThread(function()
		local elements = {
			{label="Apple",value="Apple"},
			{label="选择水果",type="slider",options={"apple","banana","orange"},description="select your favour"},
			{label="Apple123",value="Apple123",description="good health",setter="X"},--scroll and selections > 7 
			{label="Apple123",value="Apple123",setter="XY"},--scroll and selections > 7 
			{label="Apple123",value="Apple123",setter="XY"},
			{label="Apple123",value="Apple123",setter="XY"},
			{label="保存",value="Save",type="footer"},
		}
		local menuHandle = NBMenu.RequestMenu('1asda','zxcasd',"DEFAULT","ttest")
		--NBMenu.UpdateMenuHeader(menuHandle,'1asda','zxcasd') 
		NBMenu.SetMenuButtons(menuHandle,{
			NBMenu.AddButton("apple5",123,"dd","rapple"),
			NBMenu.AddSlider("apple"..math.random(0,99),{
				{"apple","Red Color and taste good"},
				{"banana","Become Smart,Become Clever"},
				{"orange","Juicy and tasty"},
				{"lame"}
			}),
			NBMenu.AddElements(elements)
		}) 
		NBMenu.SetMenuCallbacks(menuHandle,{
			function(result)
				print("OnSubmit","value:"..result.current.value)
			end,
			function(result)
				--CloseMenu(menuHandle)
				print("OnCancel","value:"..result.current.value)
			end,
			function(result)
				print("OnChange","value:"..result.current.value)
			end,
			function()
				print("OnClose")
			end
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
		NBMenu.RegisterRenderUpdate(menuHandle,function(menuRenderDatas,isUpdate)
			local render = menuRenderDatas
			if render then 
				--[=[
				print(render.title)
				print(render.description)
				for i=1,#render.slots do 
					print(render.slots[i].type)
					print(render.slots[i].ltext)
					print(render.slots[i].rtext)
					print(render.slots[i].description)
				end 
				--]=]
				local columnid = 1
				if not isUpdate then 
					PauseMenu.SetDataSlotEmpty(columnid);
					PauseMenu.SetColumnTitle(columnid,render.title,render.description or "","");
				end 
				local elements = render.slots
				local data_idx = 0
				for i=1,#elements do 
					local item = elements[i]
					if i == #elements then 
						if item.type == 'footer' then 
							PauseMenu.SetOrUpdateNormalDataSlot(columnid, data_idx, PauseMenu.menuid.HEADER_MP_CHARACTER_CREATION, data_idx, item.ltext, " " , 2, 1, isUpdate);
						else 
							PauseMenu.SetOrUpdateNormalDataSlot(columnid, data_idx, PauseMenu.menuid.HEADER_MP_CHARACTER_CREATION, data_idx, item.ltext, item.rtext , item.type == 'slider' and 0 or 1, 4, isUpdate); 
						end 
					else 
						PauseMenu.SetOrUpdateNormalDataSlot(columnid, data_idx, PauseMenu.menuid.HEADER_MP_CHARACTER_CREATION, data_idx, item.ltext, item.rtext , item.type == 'slider' and 0 or 1, 4, isUpdate);
					end 
					data_idx = data_idx + 1
				end 
				if not isUpdate then 
					PauseMenu.DisplayDataSlot(columnid);
					PauseMenu.SetColumnFocus(columnid, 1, 1);
					PauseMenu.SetColumnCanJump(columnid, 1);
					PauseMenu.SetCurrentColumn(columnid)
					if #elements>7 then 
						if columnid == 1 or columnid == 6 then 
							PauseMenu.InitColumnScroll(columnid, 1, 1, 1, 0, 0)
						end 
					end 
				end 
			end 
		end)
		--NBMenu.SetMenuAsNoLongerNeeded(menuHandle)
	end)

end 