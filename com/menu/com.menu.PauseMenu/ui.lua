if IsClient() then 
local data_idx = 0;
local Created = false 
AddEventHandler("NB:MenuOpen",function(menudata)
	print(menudata.title)
	SetFrontendActive(false);
	Wait(550)
	StartPauseMenu(PauseMenu.versionid.FE_MENU_VERSION_MP_CHARACTER_CREATION)
	Wait(550)
	SetCurrentColumn(-1)
	if not Created then 
	SetDataSlotEmpty(0);
	SetColumnTitle(0,menudata.title,menudata.description or "","");
	SetOrUpdateNormalDataSlot(0, data_idx, PauseMenu.menuid.HEADER_MP_CHARACTER_CREATION, data_idx, "FACE_SEX", IsPedMale(PlayerPedId()) and "FACE_MALE" or "FACE_FEMALE", 0, 4, Created, -1, -1, 0, 0);
	data_idx=data_idx+1;
	end 
	SetOrUpdateNormalDataSlot(0, data_idx, PauseMenu.menuid.HEADER_MP_CHARACTER_CREATION, data_idx, "FACE_SAVE", "", 1, 4, Created, -1, -1,0,0);
	data_idx=data_idx+1;
	SetOrUpdateNormalDataSlot(0, data_idx, PauseMenu.menuid.HEADER_MP_CHARACTER_CREATION, data_idx, "FACE_SAVE", "", 2, 1, Created, -1, -1,0,0);
	data_idx=data_idx+1;
	
	DisplayDataSlot(0);
	SetColumnFocus(0, 1, 1);
	SetColumnCanJump(0, 1);
	ShowColumn(0,true);
	Created = true 
	
end)


CreateThread(function()
	while true do 
	Wait(0)
		if N_0x2e22fefa0100275e() then 
			
			NB.Utils.Debug.DrawText(GetPauseMenuSelectionData())
		end 
		
		
		
	end
end)

end 