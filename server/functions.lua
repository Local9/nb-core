NB.Utils = com.lua.utils
NB.Threads = com.lua.threads
NB.RegisterServerCallback = ESX.RegisterServerCallback 


NB.SetTempSomething = function(...)
	local args = {...}
	local thisparent = NB._temp_
	local lastv = nil 
	
	for i=1,#args-1 do 
		local v = tostring(args[i])
		if thisparent[v] == nil then 
			thisparent[v] = {} 
		end 
		if i ~= #args-1 then 
			thisparent = thisparent[v]
		else 
			local t = {}
			for i,v in pairs(args) do 
				t[i] = v 
			end 
			thisparent[v] = t[#t]
			return thisparent[v]
		end 
	end 
	return nil 
end 

NB.MakeSureTempSomethingExist = function(...)
	local args = {...}
	local thisparent = NB._temp_
	local lastv = nil 
	
	for i=1,#args do 
		local v = tostring(args[i])
		if thisparent[v] == nil then 
			thisparent[v] = {} 
		end 
		if i ~= #args then 
			thisparent = thisparent[v]
		else 
			local t = {}
			for i,v in pairs(args) do 
				t[i] = v 
			end 
			if thisparent[v] == nil then 
				thisparent[v] = nil
			else 
				return thisparent[v]
			end 
			return thisparent[v]
		end 
	end 
	return nil 
end 

NB.IsTempSomthingExist = function(...)
	local args = {...}
		local thisparent = NB._temp_
		local lastv = nil 
		
		for i=1,#args do 
			local v = tostring(args[i])
			if thisparent[v] == nil then 
				return false 
			end 
			if i ~= #args then 
				thisparent = thisparent[v]
			else 
				local t = {}
				for i,v in pairs(args) do 
					t[i] = v 
				end 
				if thisparent[v] == nil then 
					return false 
				else 
					return not (thisparent[v]==nil)
				end 
				return not (thisparent[v]==nil)
			end 
		end 
		return false 
end 

NB.GetTempSomthing = function(...)
	if NB.IsTempSomthingExist("CitizenDatas",CitizenID,tablename,dataname) then 
		local GetTempSomthing_ = function(...)
			local args = {...}
			local thisparent = NB._temp_
			local lastv = nil 
			
			for i=1,#args do 
				local v = tostring(args[i])
				if thisparent[v] == nil then 
					thisparent[v] = {} 
				end 
				if i ~= #args then 
					thisparent = thisparent[v]
				else 
					local t = {}
					for i,v in pairs(args) do 
						t[i] = v 
					end 
					if thisparent[v] == nil then 
						thisparent[v] = nil
					else 
						return thisparent[v]
					end 
					return thisparent[v]
				end 
			end 
			return nil 
		end 
		local args = {...}
		local lastarg = args[#args]
		table.remove(args,#args)
		local args2 = args 
		local wtf = GetTempSomthing_(table.unpack(args2))[lastarg]
		return wtf
	else 
		return nil 
	end 
end 

NB.SendClientMessage = function(playerId, color, message)
	TriggerClientEvent('chat:addMessage',playerId, {
	  color = color == -1 and 255 or NB.Utils.Colour.HexToRGB(color,true),
	  multiline = true,
	  args = {message}
	})
end 

NB.SendClientMessageToAll = function(color,message)
	TriggerClientEvent('chat:addMessage',-1, {
	  color = color == -1 and 255 or NB.Utils.Colour.HexToRGB(color,true),
	  multiline = true,
	  args = { message}
	})
end 
