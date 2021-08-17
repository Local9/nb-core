if IsClient() then 
local menuHandle
CreateThread(function()
Wait(2000)
print('remake')
	local elements = {
	{label="Apple",value="Apple"},
	{label="选择水果",type="slider",options={"apple","banana","orange"},description="select your favour"},
	{label="Apple123",value="Apple123",description="good health",setter="X"},--scroll and selections > 7 
	{label="Apple123",value="Apple123",setter="XY"},--scroll and selections > 7 
	{label="Apple123",value="Apple123",setter="XY"},
	{label="Apple123",value="Apple123",setter="XY"},
	{label="保存",value="Save",type="footer"},
}

menuHandle = RequestMenu("DEFAULT","fishing1")
	repeat Wait(0) until HasMenuLoaded(menuHandle) 
	BeginMenuMethod(menuHandle,"SET_MENU_HEADER")
		MenuMethodAddParams("title")
		MenuMethodAddParams("description")
	EndMenuMethod()
	BeginMenuMethod(menuHandle,"SET_MENU_BUTTON")
		MenuMethodAddButton("apple5",123,"dd","rapple")
		MenuMethodAddOption("apple"..math.random(0,99),{
			{"apple","Red Color and taste good"},
			{"banana","Become Smart,Become Clever"},
			{"orange","Juicy and tasty"},
			{"lame"}
		})
		MenuMethodAddElements(elements)
	EndMenuMethod()
	BeginMenuMethod(menuHandle,"SET_MENU_CALLBACK")
		MenuMethodAddCallback(function(result)
			print("OnSubmit","value:"..result.current.value)
		end)
		MenuMethodAddCallback(function(result)
			CloseMenu(menuHandle)
			print("OnCancel","value:"..result.current.value)
		end)
		MenuMethodAddCallback(function(result)
			print("OnChange","value:"..result.current.value)
		end)
		MenuMethodAddCallback(function()
			print("OnClose")
		end)
	local menu = EndMenuMethodReturn()
	PauseMenu.StartPauseMenu(PauseMenu.versionid.FE_MENU_VERSION_MP_CHARACTER_CREATION)
	NBMenu.OnRenderUpdate(menuHandle,function(render,isUpdate)
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
	
	NB.RegisterKeyEvent('test',function(input)
		print(input)
	end )
	--SetMenuAsNoLongerNeeded(menuHandle)

end)
end 
--[=[
CreateThread(function()
	function GetPos ()
		local a,b,c = GetPauseMenuSelectionData()
		if c ~= -1 then 
			return c+1 
		else 
			return 1
		end 
	end 
	
	repeat Wait(300)
		if HasMenuLoaded(menuHandle) then 
			NBMenu.SetCurrentSlot(menuHandle,GetPos ())
			
			if NBMenu.IsCurrentSlotSlider(menuHandle) then
				NBMenu.SetCurrentItemSlot(menuHandle,math.random(1,5))
			end 
			NBMenu.ConvertCurrentItemForCallback(menuHandle,"Change")
			
		end 
		
	until false 
end)--]=]


