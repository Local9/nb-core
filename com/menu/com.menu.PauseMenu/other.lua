if IsClient() then 
CreateThread(function()
	SetFrontendActive(false);
	Wait(500)
	StartPauseMenu(PauseMenu.versionid.FE_MENU_VERSION_MP_CHARACTER_CREATION)
	Wait(500)
	SetCurrentColumn(-1)
	
	--123235
	
	CreateMain()
	
end)

CreateThread(function()
	while true do 
	Wait(0)
		if N_0x2e22fefa0100275e() then 
			
			NB.Utils.Debug.DrawText(GetPauseMenuSelectionData())
		end 
		
		
		
	end
end)
local data_idx = 0;
function CreateMain(Created)
	if not Created then
		SetDataSlotEmpty(0);
		
		SetColumnTitle(0,"FACE_TITLE","","");
		SetOrUpdateNormalDataSlot(0, data_idx, PauseMenu.menuid.HEADER_MP_CHARACTER_CREATION, 0, "FACE_SEX", IsPedMale(PlayerPedId()) and "FACE_MALE" or "FACE_FEMALE", 0, 4, Created, -1, -1, 0, 0);
		data_idx=data_idx+1;
	end
	SetOrUpdateNormalDataSlot(0, data_idx, PauseMenu.menuid.HEADER_MP_CHARACTER_CREATION, 1, "FACE_HERI", "", 1, 4, Created, -1, -1, 0, 0);
	data_idx=data_idx+1;
	SetOrUpdateNormalDataSlot(0, data_idx, PauseMenu.menuid.HEADER_MP_CHARACTER_CREATION, 2, "FACE_FEAT", "", 1, 4, Created, -1, -1, 0, 0);
	data_idx=data_idx+1;
	SetOrUpdateNormalDataSlot(0, data_idx, PauseMenu.menuid.HEADER_MP_CHARACTER_CREATION, 3, "FACE_APP", "", 1, 4, Created, -1, -1, 0, 0);
	data_idx=data_idx+1;
	SetOrUpdateNormalDataSlot(0, data_idx, PauseMenu.menuid.HEADER_MP_CHARACTER_CREATION, 4, "FACE_APPA", "", 1, 4, Created, -1, -1, 0, 0);
	data_idx=data_idx+1;
	SetOrUpdateNormalDataSlot(0, data_idx, PauseMenu.menuid.HEADER_MP_CHARACTER_CREATION, 5, "FACE_STATS", "", 1, 4, Created, -1, -1, 0, 0);
	data_idx=data_idx+1;
	if not Created then
		SetOrUpdateNormalDataSlot(0, data_idx, PauseMenu.menuid.HEADER_MP_CHARACTER_CREATION, 6, "FACE_SAVE", "", 2, 1, Created, -1, -1, 0, 0);
		data_idx=data_idx+1;
		DisplayDataSlot(0);
		SetColumnFocus(0, 1, 1);
		SetColumnCanJump(0, 1);
	end
	ShowColumn(0,true);
	Wait(5555)
	Created = true
	SetOrUpdateNormalDataSlot(0, 0, PauseMenu.menuid.HEADER_MP_CHARACTER_CREATION, 0, "FACE_SEX", "FACE_FEMALE", 0, 4, Created, -1, -1, 0, 0);
		
end
end 