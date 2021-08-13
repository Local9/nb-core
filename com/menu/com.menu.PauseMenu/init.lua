if IsClient() then 
PauseMenu={}
PauseMenu.menuid = 
{
   MAP = 1000;
   INFO = 1001;
   FRIENDS = 1002;
   GALLERY = 1003;
   SOCIALCLUB = 1004;
   GAME = 1005;
   SETTINGS = 1006;
   PLAYERS = 1007;
   WEAPONS = 1008;
   MEDALS = 1009;
   STATS = 1010;
   AVAILABLE = 1011;
   VAGOS = 1012;
   COPS = 1013;
   LOST = 1014;
   HOME_MISSION = 1015;
   CORONA_SETTINGS = 1016;
   CORONA_INVITE = 1017;
   STORE = 1018;
   HOME_HELP = 1019;
   HOME_BRIEF = 1020;
   HOME_FEED = 1021;
   SETTINGS_AUDIO = 1022;
   SETTINGS_DISPLAY = 1023;
   SETTINGS_CONTROLS = 1024;
   NEW_GAME = 1025;
   LOAD_GAME = 1026;
   SAVE_GAME = 1027;
   HEADER = 1028;
   HEADER_SAVE_GAME = 1029;
   HOME = 1030;
   CREWS = 1031;
   SETTINGS_SAVEGAME = 1032;
   GALLERY_ITEM = 1033;
   FREEMODE = 1034;
   MP_CHAR_1 = 1035;
   MP_CHAR_2 = 1036;
   MP_CHAR_3 = 1037;
   MP_CHAR_4 = 1038;
   MP_CHAR_5 = 1039;
   HEADER_MULTIPLAYER = 1040;
   HEADER_MY_MP = 1041;
   MISSION_CREATOR = 1042;
   GAME_MP = 1043;
   LEAVE_GAME = 1044;
   HEADER_PRE_LOBBY = 1045;
   HEADER_LOBBY = 1046;
   PARTY = 1047;
   LOBBY = 1048;
   PLACEHOLDER = 1049;
   STATS_CATEGORY = 1050;
   SETTINGS_LIST = 1051;
   SAVE_GAME_LIST = 1052;
   MAP_LEGEND = 1053;
   CREWS_CATEGORY = 1054;
   CREWS_FILTER = 1055;
   CREWS_CARD = 1056;
   SPECTATOR = 1057;
   STATS_LISTITEM = 1058;
   CREW_MINE = 1059;
   CREW_ROCKSTAR = 1060;
   CREW_FRIENDS = 1061;
   CREW_INVITES = 1062;
   CREW_LIST = 1063;
   MISSION_CREATOR_CATEGORY = 1064;
   MISSION_CREATOR_LISTITEM = 1065;
   MISSION_CREATOR_STAT = 1066;
   FRIENDS_LIST = 1067;
   FRIENDS_OPTIONS = 1068;
   HEADER_MP_CHARACTER_SELECT = 1069;
   HEADER_MP_CHARACTER_CREATION = 1070;
   CREATION_HERITAGE = 1071;
   CREATION_LIFESTYLE = 1072;
   CREATION_YOU = 1073;
   PARTY_LIST = 1074;
   REPLAY_MISSION = 1075;
   REPLAY_MISSION_LIST = 1076;
   REPLAY_MISSION_ACTIVITY = 1077;
   CREW = 1078;
   CREATION_HERITAGE_LIST = 1079;
   CREATION_LIFESTYLE_LIST = 1080;
   PLAYERS_LIST = 1081;
   PLAYERS_OPTIONS = 1082;
   PLAYERS_OPTIONS_LIST = 1083;
   PARTY_OPTIONS = 1084;
   PARTY_OPTIONS_LIST = 1085;
   CREW_OPTIONS = 1086;
   CREW_OPTIONS_LIST = 1087;
   FRIENDS_OPTIONS_LIST = 1088;
   FRIENDS_MP = 1089;
   TEAM_SELECT = 1090;
   HOME_DIALOG = 1091;
   HEADER_EMPTY = 1092;
   SETTINGS_FEED = 1093;
   GALLERY_OPTIONS = 1094;
   GALLERY_OPTIONS_LIST = 1095;
   BRIGHTNESS_CALIBRATION = 1096;
   HEADER_TEXT_SELECTION = 1097;
   LOBBY_LIST = 1098;
   LOBBY_LIST_ITEM = 1099;
   HEADER_CORONA = 1100;
   HEADER_CORONA_LOBBY = 1101;
   HEADER_CORONA_JOINED_PLAYERS = 1102;
   HEADER_CORONA_INVITE_PLAYERS = 1103;
   HEADER_CORONA_INVITE_FRIENDS = 1104;
   HEADER_CORONA_INVITE_CREWS = 1105;
   CORONA_JOINED_PLAYERS = 1106;
   CORONA_INVITE_PLAYERS = 1107;
   CORONA_INVITE_FRIENDS = 1108;
   CORONA_INVITE_CREWS = 1109;
   SETTINGS_FACEBOOK = 1110;
   HEADER_JOINING_SCREEN = 1111;
   CORONA_SETTINGS_LIST = 1112;
   CORONA_DETAILS_LIST = 1113;
   CORONA_INVITE_LIST = 1114;
   CORONA_JOINED_LIST = 1115;
   HEADER_CORONA_INVITE_MATCHED_PLAYERS = 1116;
   HEADER_CORONA_INVITE_LAST_JOB_PLAYERS = 1117;
   CORONA_INVITE_MATCHED_PLAYERS = 1118;
   CORONA_INVITE_LAST_JOB_PLAYERS = 1119;
   CREW_LEADERBOARDS = 1120;
   HOME_OPEN_JOBS = 1121;
   CREW_REQUEST = 1122;
   HEADER_RACE = 1123;
   RACE_INFO = 1124;
   RACE_INFOLIST = 1125;
   RACE_LOBBYLIST = 1126;
   HEADER_BETTING = 1127;
   BETTING = 1128;
   BETTING_INFOLIST = 1129;
   BETTING_LOBBYLIST = 1130;
   INCEPT_TRIGGER = 1131;
   SETTINGS_SIXAXIS = 1132;
   REPLAY_RANDOM = 1133;
   CUTSCENE_EMPTY = 1134;
   HOME_NEWSWIRE = 1135;
   SETTINGS_CAMERA = 1136;
   SETTINGS_VIDEO = 1137;
   SETTINGS_GRAPHICS = 1138;
   SETTINGS_VOICE_CHAT = 1139;
   SETTINGS_MISC_CONTROLS = 1140;
   HELP = 1141;
   MOVIE_EDITOR = 1142;
   EXIT_TO_WINDOWS = 1143;
   HEADER_LANDING_PAGE = 1144;
   SHOW_ACCOUNT_PICKER = 1145;
   SETTINGS_REPLAY = 1146;
   REPLAY_EDITOR = 1147;
   MENU_UNIQUE_ID_SETTINGS_FPS = 1148;
}
PauseMenu.versionid = 
{
FE_MENU_VERSION_SP_PAUSE=`FE_MENU_VERSION_SP_PAUSE`,
FE_MENU_VERSION_MP_PAUSE=`FE_MENU_VERSION_MP_PAUSE`,
FE_MENU_VERSION_CREATOR_PAUSE=`FE_MENU_VERSION_CREATOR_PAUSE`,
FE_MENU_VERSION_CUTSCENE_PAUSE=`FE_MENU_VERSION_CUTSCENE_PAUSE`,
FE_MENU_VERSION_SAVEGAME=`FE_MENU_VERSION_SAVEGAME`,
FE_MENU_VERSION_PRE_LOBBY=`FE_MENU_VERSION_PRE_LOBBY`,
FE_MENU_VERSION_LOBBY=`FE_MENU_VERSION_LOBBY`,
FE_MENU_VERSION_MP_CHARACTER_SELECT=`FE_MENU_VERSION_MP_CHARACTER_SELECT`,
FE_MENU_VERSION_MP_CHARACTER_CREATION=`FE_MENU_VERSION_MP_CHARACTER_CREATION`,
FE_MENU_VERSION_EMPTY=`FE_MENU_VERSION_EMPTY`,
FE_MENU_VERSION_EMPTY_NO_BACKGROUND=`FE_MENU_VERSION_EMPTY_NO_BACKGROUND`,
FE_MENU_VERSION_TEXT_SELECTION=`FE_MENU_VERSION_TEXT_SELECTION`,
FE_MENU_VERSION_CORONA=`FE_MENU_VERSION_CORONA`,
FE_MENU_VERSION_CORONA_LOBBY=`FE_MENU_VERSION_CORONA_LOBBY`,
FE_MENU_VERSION_CORONA_JOINED_PLAYERS=`FE_MENU_VERSION_CORONA_JOINED_PLAYERS`,
FE_MENU_VERSION_CORONA_INVITE_PLAYERS=`FE_MENU_VERSION_CORONA_INVITE_PLAYERS`,
FE_MENU_VERSION_CORONA_INVITE_FRIENDS=`FE_MENU_VERSION_CORONA_INVITE_FRIENDS`,
FE_MENU_VERSION_CORONA_INVITE_CREWS=`FE_MENU_VERSION_CORONA_INVITE_CREWS`,
FE_MENU_VERSION_CORONA_INVITE_MATCHED_PLAYERS=`FE_MENU_VERSION_CORONA_INVITE_MATCHED_PLAYERS`,
FE_MENU_VERSION_CORONA_INVITE_LAST_JOB_PLAYERS=`FE_MENU_VERSION_CORONA_INVITE_LAST_JOB_PLAYERS`,
FE_MENU_VERSION_CORONA_RACE=`FE_MENU_VERSION_CORONA_RACE`,
FE_MENU_VERSION_CORONA_BETTING=`FE_MENU_VERSION_CORONA_BETTING`,
FE_MENU_VERSION_JOINING_SCREEN=`FE_MENU_VERSION_JOINING_SCREEN`,
FE_MENU_VERSION_LANDING_MENU=`FE_MENU_VERSION_LANDING_MENU`,
FE_MENU_VERSION_LANDING_KEYMAPPING_MENU=`FE_MENU_VERSION_LANDING_KEYMAPPING_MENU`					
}
local start = BeginScaleformMovieMethodOnFrontend
local send = function (...)
    local tb = {...}
    for i=1,#tb do
        if type(tb[i]) == "number" then 
            if math.type(tb[i]) == "integer" then
                    ScaleformMovieMethodAddParamInt(tb[i])
            else
                    ScaleformMovieMethodAddParamFloat(tb[i])
            end
        elseif type(tb[i]) == "string" then ScaleformMovieMethodAddParamTextureNameString(tb[i])
        elseif type(tb[i]) == "boolean" then ScaleformMovieMethodAddParamBool(tb[i])
        end
    end 
	EndScaleformMovieMethod()
end
function StartPauseMenu(versionHash)
	if GetCurrentFrontendMenuVersion() ~= versionHash then
			SetFrontendActive(false);
		end
		SetFrontendActive(false);
		ActivateFrontendMenu(versionHash, false, -1);
		Wait(500)
		RestartFrontendMenu(versionHash,-1)
end
function InitColumnScroll(Param0, Param1, Param2, Param3, Param4, Param5)

	BeginScaleformMovieMethodOnFrontend("INIT_COLUMN_SCROLL");
	ScaleformMovieMethodAddParamInt(Param0);
	ScaleformMovieMethodAddParamBool(false);
	ScaleformMovieMethodAddParamInt(Param1);
	ScaleformMovieMethodAddParamInt(Param2);
	ScaleformMovieMethodAddParamInt(Param3);
	ScaleformMovieMethodAddParamBool(true);
	ScaleformMovieMethodAddParamInt(Param4);
	ScaleformMovieMethodAddParamBool(Param5);
	EndScaleformMovieMethod();
end
function SetColumnCanJump(Param0, Param1)

	if BeginScaleformMovieMethodOnFrontend("SET_COLUMN_CAN_JUMP") then
	
		ScaleformMovieMethodAddParamInt(Param0);
		ScaleformMovieMethodAddParamBool(not Param1);
		EndScaleformMovieMethod();
	end
end

function SetColumnHighLight(Param0, Param1, Param2)

	if BeginScaleformMovieMethodOnFrontend("SET_COLUMN_HIGHLIGHT") then
	
		ScaleformMovieMethodAddParamInt(Param0);
		ScaleformMovieMethodAddParamInt(Param1);
		ScaleformMovieMethodAddParamBool(false);
		ScaleformMovieMethodAddParamBool(Param2);
		EndScaleformMovieMethod();
	end
end
function SetDescription(Param0, Param1, Param2, Param3, Param4)

	if BeginScaleformMovieMethodOnFrontend("SET_DESCRIPTION") then
	
		ScaleformMovieMethodAddParamInt(Param0);
		BeginTextCommandScaleformString(Param1);
		if Param3 ~= -1 then
		
			AddTextComponentInteger(Param3);
		end
		if not IsStringNullOrEmpty(Param4) then
		
			ScaleformMovieMethodAddParamTextureNameString(Param4);
		end
		EndTextCommandScaleformString_2();
		ScaleformMovieMethodAddParamBool(Param2);
		EndScaleformMovieMethod();
	end
end
function SetMenuColumnTitle(columnid,text,desc1,desc2)
	start('SET_COLUMN_TITLE')
	send(columnid,text,desc1,desc2)
end 
function SetDataSlot(columnid,rowidx,menuid,uniqueid,...)
	start('SET_DATA_SLOT')
    send(columnid,rowidx,menuid,uniqueid,...)
	
end 
function SetDataSlotEmpty(Param0)

	if BeginScaleformMovieMethodOnFrontend("SET_DATA_SLOT_EMPTY") then
	
		ScaleformMovieMethodAddParamInt(Param0);
		EndScaleformMovieMethod();
	end
end
function DisplayDataSlot(slotid)
	start('DISPLAY_DATA_SLOT')
    send(slotid)
end 
function ShowColumn(columnid, show)

	if BeginScaleformMovieMethodOnFrontend("SHOW_COLUMN") then
	
		ScaleformMovieMethodAddParamInt(columnid);
		ScaleformMovieMethodAddParamBool(show);
		EndScaleformMovieMethod();
	end
end
function SetColumnFocus(columnid,heighlightidx,uniqueid,menustate)
	start('SET_COLUMN_FOCUS')
	send(columnid,heighlightidx,uniqueid,menustate)
end 
function SetMenuHeaderTextByIndex(columnid,columntext,columnwidth,uppercase)
	start('SET_MENU_HEADER_TEXT_BY_INDEX')
	send(columnid,columntext,columnwidth,uppercase)
end 
function SetColumnTitle(Param0, Param1, Param2, Param3)

	if BeginScaleformMovieMethodOnFrontend("SET_COLUMN_TITLE") then
	
		ScaleformMovieMethodAddParamInt(Param0);
		ScaleformMovieMethodAddParamTextureNameString(Param1);
		
		if Param2 then 
		ScaleformMovieMethodAddParamTextureNameString(Param2);
		
		end 
		if Param3 then 
		ScaleformMovieMethodAddParamTextureNameString(Param3);
		
		end 
		EndScaleformMovieMethod();
	end
end
function SetCurrentColumn(columnid)
	for i=0,7 do
		ShowColumn(i, 0);
	end
	if columnid >= 0 then
		ShowColumn(columnid, 1);
	end
end
local Var0;
function SetOrUpdateNormalDataSlot(columnid, rowidx, menuid, uniqueid, textlabel, Param5, state, Param7, Param8, Param9, Param10, Param11, Param12)

	
	
	Var0 = "SET_DATA_SLOT";
	if Param8 then
	
		Var0 = "UPDATE_SLOT";
	end
	if BeginScaleformMovieMethodOnFrontend(Var0) then
	
		ScaleformMovieMethodAddParamInt(columnid);
		ScaleformMovieMethodAddParamInt(rowidx);
		ScaleformMovieMethodAddParamInt(menuid);
		ScaleformMovieMethodAddParamInt(uniqueid);
		ScaleformMovieMethodAddParamInt(state);
		ScaleformMovieMethodAddParamInt(-1);
		ScaleformMovieMethodAddParamInt(Param7);
		ScaleformMovieMethodAddParamTextureNameString(textlabel);
		ScaleformMovieMethodAddParamInt(0);
		ScaleformMovieMethodAddParamInt(0);
		if IsStringNullOrEmpty(Param5) then
		
			if Param9 ~= -1 then
			
				ScaleformMovieMethodAddParamInt(Param9);
			
			elseif Param10 ~= -1 then
			
				ScaleformMovieMethodAddParamInt(Param10);
			
			else
			
				BeginTextCommandScaleformString("STRING");
				if not IsStringNullOrEmpty(Param11) then
				
					ScaleformMovieMethodAddParamTextureNameString(Param11);
				
				else
				
					ScaleformMovieMethodAddParamTextureNameString("");
				end
				EndTextCommandScaleformString();
			end
		
		else
		
			BeginTextCommandScaleformString(Param5);
			if not IsStringNullOrEmpty(Param11) then
			
				if Param12 then
					
					ScaleformMovieMethodAddParamTextureNameString(Param11);
				
				else
				
					AddTextComponentSubstringTextLabel(Param11);
				end
			
			elseif Param12 then
			
				ScaleformMovieMethodAddParamTextureNameString("");
			end
			
		end
		if Param9 ~= -1 then
		
			AddTextComponentInteger(Param9);
		end
		if Param10 ~= -1 then
		
			AddTextComponentInteger(Param10);
		end
		EndTextCommandScaleformString();
		if state == 2 then
		
			ScaleformMovieMethodAddParamInt(116);
		
		else
		
			ScaleformMovieMethodAddParamTextureNameString("");
		end
		EndScaleformMovieMethod();
	end
end

end


