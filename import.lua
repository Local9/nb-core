local function IsServer() return IsDuplicityVersion() end ;
local function IsClient() return not IsDuplicityVersion() end ;
local function IsShared() return true end ;
--IMPORT--
if GetCurrentResourceName() ~= "nb-core" then --a must, otherwise function becomes table in main framework script
NB = exports['nb-core']:GetSharedObject()

end 
--Shared Global Functions--
if IsShared() then 
	load(LoadResourceFile("nb-core", 'com/selfishref/threads.lua'))()
	print('loaded')
	MakeRandomSeed = NB.RandomSeed  
	printf = function(s,...) return print(s:format(...)) end
	strlen = string.len
	strval = tonumber
	strfind = string.find
	strcmp = function(string1,string2,ignorecase)
		local bool = false
		if ignorecase then 
			bool = string1:lower() == string2:lower()
		end 
		return string1 == string2
	end 
	tolower = string.lower 
	toupper = string.upper
	random = function(a,b,reseed)
		if type(b) == 'boolean' then 
			MakeRandomSeed()
			b = nil
			reseed = nil
		end 
		if reseed then MakeRandomSeed() end
		if not b then 
			if math.type(a) == 'float' then 
				return (math.random() * (a)) 
			else 
				return math.floor(math.random(0,a))
			end 
		else 
			if math.type(a) == 'float' or math.type(b) == 'float' then 
				return (math.random() * (b - a )) + a
			else 
				return math.floor(math.random(a,b))
			end 
		end 
	end 
	
	Ban = NB.BanPlayer
	
	
end 
if IsServer() then 
	RegisterServerCallback = NB.RegisterServerCallback 
	SendClientMessage = function(playerId, color, message)
		TriggerClientEvent('chat:addMessage',playerId, {
		  color = color == -1 and 255 or NB.Utils.Colour.HexToRGB(color,true),
		  multiline = true,
		  args = {message}
		})
	end 
	SendClientMessageToAll = function(color,message)
		TriggerClientEvent('chat:addMessage',-1, {
		  color = color == -1 and 255 or NB.Utils.Colour.HexToRGB(color,true),
		  multiline = true,
		  args = { message}
		})
	end 
end 
if IsClient() then 
	TriggerServerCallback = NB.TriggerServerCallback 
	local Draw3DTexts = {}
	local Draw3DTextIndex = 0
	Delete3DTextLabel = function(handle)
		NB.Threads.KillActionOfLoop(Draw3DTexts[handle].actionname)
		NB.Threads.ArrivalDelete(Draw3DTexts[handle].actionname)
	end 
	local DrawText3D = function(coords, text, textsizeX,textsizeY,width,height,font,color,outline,usebox,boxcolor)
		
		
		SetScriptGfxDrawOrder(1)
		SetTextScale(textsizeX, textsizeY)
		SetTextFont(font)
		SetTextColour(table.unpack(color))
		if outline > 0  then 
			SetTextOutline()
		end 
		SetTextCentre(true)
		BeginTextCommandDisplayText('STRING')
		AddTextComponentSubstringPlayerName(text)
		SetDrawOrigin(coords, 0)
		EndTextCommandDisplayText(0.0, 0.0)
		if usebox > 0  then 
			SetScriptGfxDrawOrder(0)
			DrawRect(0.0, 0.0+height/2+height/4,width,height,table.unpack(boxcolor))
		end 
		ClearDrawOrigin()
		
		
	end
	Create3DTextLabel = function(text, color, font, x, y, z, drawdistance, virtualworld, testLOS) --virtualworld : RoutingBucket
		local coords = vector3(x, y, z)
		Draw3DTextIndex = Draw3DTextIndex + 1
		local handle = Draw3DTextIndex
		local actionname = "Draw3DTextIndex"..Draw3DTextIndex
		local width
		BeginTextCommandGetWidth('STRING')
		AddTextComponentSubstringPlayerName(text)
		width = EndTextCommandGetWidth(1)
		local height = GetRenderedCharacterHeight(0.5,0)
		Draw3DTexts[handle] = {actionname =  actionname,attachentity = nil,drawdistance=drawdistance,coords=coords,textsizeX=0.5,textsizeY=0.5,width=width,height=height,text = text,font = 0,color={255,255,255,255},outline = 1,usebox = 1,boxcolor={255,255,255,255} }

		CreateThread(function()
			if not NB.Threads.IsArrivalExist(Draw3DTexts[handle].actionname) then 
				NB.Threads.AddPosition(Draw3DTexts[handle].actionname,Draw3DTexts[handle].coords,Draw3DTexts[handle].drawdistance+0.0,function(result)
					if result.action == 'enter' then 
						NB.Threads.CreateLoopOnce(Draw3DTexts[handle].actionname,0,function(Break)
							local camCoords = GetGameplayCamCoords()
							local distance = #(coords - camCoords)
							if not font then font = 0 end
							local scale = (1 / distance) * 2
							local fov = (1 / GetGameplayCamFov()) * 100
							scale = scale * fov
							local height = GetRenderedCharacterHeight(Draw3DTexts[handle].textsizeY,0)
							
							DrawText3D(Draw3DTexts[handle].coords, Draw3DTexts[handle].text, Draw3DTexts[handle].textsizeX*scale,Draw3DTexts[handle].textsizeY*scale,Draw3DTexts[handle].width*scale,Draw3DTexts[handle].height*scale,Draw3DTexts[handle].font,Draw3DTexts[handle].color,Draw3DTexts[handle].outline,Draw3DTexts[handle].usebox,Draw3DTexts[handle].boxcolor)	
						end)
					elseif  result.action == 'exit' then 
						NB.Threads.KillActionOfLoop(Draw3DTexts[handle].actionname)
					end 
				end)
			end 
		end)
		return handle
	end 
	Update3DTextLabelColor = function(handle,color) -- 0xff0000ff
		Draw3DTexts[handle].color = NB.Utils.Colour.HexToRGBA(color,true) 
	end 
	Update3DTextLabelFont = function(handle,font)
		Draw3DTexts[handle].font = font
	end 
	Update3DTextLabelSetOutline = function(handle,isoutline)
		Draw3DTexts[handle].outline = isoutline and 1 or 0
	end 
	Update3DTextLabelUseBox = function(handle,isusebox)
		Draw3DTexts[handle].usebox = isusebox and 1 or 0
	end 
	Update3DTextLabelTextSize = function(handle,textsizeX,textsizeY) 
		Draw3DTexts[handle].textsizeX = textsizeX
		Draw3DTexts[handle].textsizeY = textsizeY
		local width
		BeginTextCommandGetWidth('STRING')
		AddTextComponentSubstringPlayerName(Draw3DTexts[handle].text)
		width = EndTextCommandGetWidth(1)
		Draw3DTexts[handle].width = width
		Draw3DTexts[handle].height = GetRenderedCharacterHeight(textsizeY,0)
	end 
	Update3DTextLabelBoxColor = function(handle,boxcolor) -- 0xff0000ff
		Draw3DTexts[handle].boxcolor = NB.Utils.Colour.HexToRGBA(boxcolor,true)
	end 
	Update3DTextLabelSetString = function(handle,text)
		Draw3DTexts[handle].text = text
		local width
		BeginTextCommandGetWidth('STRING')
		AddTextComponentSubstringPlayerName(Draw3DTexts[handle].text)
		width = EndTextCommandGetWidth(1)
		Draw3DTexts[handle].width = width
		Draw3DTexts[handle].height = GetRenderedCharacterHeight(Draw3DTexts[handle].textsizeY,0)
	end 
	Attach3DTextLabelToEntity = function(handle,entity,offsetX,offsetY,offsetZ)
		Draw3DTexts[handle].attachentity = entity
		if NB.Threads.IsArrivalExist(Draw3DTexts[handle].actionname) then 
			NB.Threads.ArrivalDelete(Draw3DTexts[handle].actionname)
		end 
		if NB.Threads.IsActionOfLoopAlive(Draw3DTexts[handle].actionname) then 
			NB.Threads.KillActionOfLoop(Draw3DTexts[handle].actionname)
		end 
		if DoesEntityExist(Draw3DTexts[handle].attachentity) then 
			NB.Threads.CreateLoopOnce(Draw3DTexts[handle].actionname.."player",0,function(Break)
				local entity = Draw3DTexts[handle].attachentity
				if DoesEntityExist(entity) then 
					Draw3DTexts[handle].coords = GetOffsetFromEntityInWorldCoords(entity ,offsetX ,offsetY ,offsetZ )
					if #(GetEntityCoords(PlayerPedId()) - Draw3DTexts[handle].coords) < Draw3DTexts[handle].drawdistance then 
						if not font then font = 0 end
						local scale = 1.0
						local height = GetRenderedCharacterHeight(Draw3DTexts[handle].textsizeY,0)
						DrawText3D(Draw3DTexts[handle].coords, Draw3DTexts[handle].text, Draw3DTexts[handle].textsizeX*scale,Draw3DTexts[handle].textsizeY*scale,Draw3DTexts[handle].width*scale,Draw3DTexts[handle].height*scale,Draw3DTexts[handle].font,Draw3DTexts[handle].color,Draw3DTexts[handle].outline,Draw3DTexts[handle].usebox,Draw3DTexts[handle].boxcolor)	
					end 
				end 
			end)
		end 
	end 
	Attach3DTextLabelToPlayer = function(handle,playerid,...)
		return Attach3DTextLabelToEntity(handle,GetPlayerPed(playerid),...)
	end 
	Attach3DTextLabelToPed = Attach3DTextLabelToEntity
	Attach3DTextLabelToVehicle = Attach3DTextLabelToEntity
	Attach3DTextLabelToObject = Attach3DTextLabelToEntity
	
	local TextDraws = {}
	local TextDrawsIndex = 0
	local DrawText2D = function(text,x,y,textsizeX,textsizeY,width,height,font,color,outline,usebox,boxcolor)
		SetScriptGfxDrawOrder(1)
		SetTextScale(textsizeX, textsizeY)
		SetTextFont(font)
		SetTextColour(table.unpack(color))
		if outline > 0  then 
			SetTextOutline()
		end 
		SetTextCentre(true)
		BeginTextCommandDisplayText('STRING')
		AddTextComponentSubstringPlayerName(text)
		EndTextCommandDisplayText(x, y)
		if usebox > 0  then 
			SetScriptGfxDrawOrder(0)
			DrawRect(x, y+height/2+height/4,width,height,table.unpack(boxcolor))
		end 
		ClearDrawOrigin()
	end
	TextDrawDestroy = function(handle)
		if NB.Threads.IsActionOfLoopAlive(TextDraws[handle].actionname) then
			NB.Threads.KillActionOfLoop(TextDraws[handle].actionname)
		end
		TextDraws[handle] = nil
	end 
	TextDrawCreate = function(xper,yper,text)
		TextDrawsIndex = TextDrawsIndex + 1
		local handle = TextDrawsIndex
		local actionname = "TextDrawsIndex"..TextDrawsIndex
		local width
		BeginTextCommandGetWidth('STRING')
		AddTextComponentSubstringPlayerName(text)
		width = EndTextCommandGetWidth(1)
		local height = GetRenderedCharacterHeight(0.5,0)
		TextDraws[handle] = {actionname =  actionname,x = xper,y = yper,textsizeX=0.5,textsizeY=0.5,width=width,height=height,text = text,font = 0,color={255,255,255,255},outline = 1,usebox = 1,boxcolor={255,255,255,255} }
		return handle 
	end 
	TextDrawShow = function(handle)
		if TextDraws[handle].hide then 
			TextDraws[handle].hide = nil
		end 	
		NB.Threads.CreateLoopOnce(TextDraws[handle].actionname,0,function()
			if not TextDraws[handle].hide then 
				DrawText2D(TextDraws[handle].text,TextDraws[handle].x,TextDraws[handle].y,TextDraws[handle].textsizeX,TextDraws[handle].textsizeY,TextDraws[handle].width,TextDraws[handle].height,TextDraws[handle].font,TextDraws[handle].color,TextDraws[handle].outline,TextDraws[handle].usebox,TextDraws[handle].boxcolor)
			end 
		end)
	end 
	TextDrawHide = function(handle,color)
		TextDraws[handle].hide = true
	end 
	TextDrawColor = function(handle,color) -- 0xff0000ff
		TextDraws[handle].color = NB.Utils.Colour.HexToRGBA(color,true) 
	end 
	TextDrawFont = function(handle,font)
		TextDraws[handle].font = font
	end 
	TextDrawSetOutline = function(handle,isoutline)
		TextDraws[handle].outline = isoutline and 1 or 0
	end 
	TextDrawUseBox = function(handle,isusebox)
		TextDraws[handle].usebox = isusebox and 1 or 0
	end 
	TextDrawTextSize = function(handle,textsizeX,textsizeY) 
		TextDraws[handle].textsizeX = textsizeX
		TextDraws[handle].textsizeY = textsizeY
		local width
		BeginTextCommandGetWidth('STRING')
		AddTextComponentSubstringPlayerName(TextDraws[handle].text)
		width = EndTextCommandGetWidth(1)
		TextDraws[handle].width = width
		TextDraws[handle].height = GetRenderedCharacterHeight(textsizeY,0)
	end 
	TextDrawBoxColor = function(handle,boxcolor) -- 0xff0000ff
		TextDraws[handle].boxcolor = NB.Utils.Colour.HexToRGBA(boxcolor,true)
	end 
	TextDrawSetString = function(handle,text)
		TextDraws[handle].text = text
		local width
		BeginTextCommandGetWidth('STRING')
		AddTextComponentSubstringPlayerName(TextDraws[handle].text)
		width = EndTextCommandGetWidth(1)
		TextDraws[handle].width = width
		TextDraws[handle].height = GetRenderedCharacterHeight(TextDraws[handle].textsizeY,0)
	end 

end 