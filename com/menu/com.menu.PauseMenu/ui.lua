if IsClient() then 
local data_idx = 0;

AddEventHandler("NB:MenuOpen",function(menudata)
	local Created = false 
	print(menudata.title)
	SetFrontendActive(false);
	Wait(550)
	StartPauseMenu(PauseMenu.versionid.FE_MENU_VERSION_MP_CHARACTER_CREATION)
	Wait(550)
	SetCurrentColumn(-1)
	if not Created then 
		SetDataSlotEmpty(0);
		SetColumnTitle(0,menudata.title,menudata.description or "","");
		for i=1,#menudata.elements do 
			local item = menudata.elements[i]
			local data_idx = i-1
			SetOrUpdateNormalDataSlot(0, data_idx, PauseMenu.menuid.HEADER_MP_CHARACTER_CREATION, data_idx, item.label, item.type == 'slider' and item.options[1] or "" , item.type == 'slider' and 0 or 1, 4, Created, -1, -1, 0 , 0);
		end 
		
		--SetOrUpdateNormalDataSlot(0, #menudata.elements, PauseMenu.menuid.HEADER_MP_CHARACTER_CREATION, #menudata.elements, "FACE_SAVE", "", 2, 1, Created, -1, -1,0,0);
		 
		DisplayDataSlot(0);
		SetColumnFocus(0, 1, 1);
		SetColumnCanJump(0, 1);
		ShowColumn(0,true);
	end
	
end)
AddEventHandler("NB:MenuUpdate",function(menudata,pos)
	print('update',pos,pos-1)
	local Created = true 
	local item = menudata.elements[pos]
	local data_idx = pos-1
	SetOrUpdateNormalDataSlot(0, data_idx, PauseMenu.menuid.HEADER_MP_CHARACTER_CREATION, data_idx, item.label, item.type == 'slider' and item.value or "" , item.type == 'slider' and 0 or 1, 4, Created, -1, -1, 0 , 0);
	
	
	
end)


end 