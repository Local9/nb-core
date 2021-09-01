if IsClient() then 
local MugShotStr = ""
local mugshot = 0
com.game.Client.Mugshot.Set = function()
	local ped = PlayerPedId()
	
	if IsStringNullOrEmpty(MugShotStr) then 
		
		if DoesEntityExist(ped)  then 
			
			if mugshot ~= 0 then 
				if IsPedheadshotValid(mugshot) then 
					if IsPedheadshotReady(mugshot) then 
						MugShotStr = GetPedheadshotTxdString(mugshot)
					end 
				end 
			
			else 
				mugshot = RegisterPedheadshot(ped) 
			end 
		end 
	
	end 
end

com.game.Client.Mugshot.Clear = function()
	if IsPedheadshotValid(mugshot) then
		if mugshot ~= 0 then
			MugShotStr = GetPedheadshotTxdString(mugshot)
			ThefeedAddTxdRef(MugShotStr, MugShotStr, "CHAR_DEFAULT", "CHAR_DEFAULT");
		end
		UnregisterPedheadshot(mugshot);
		mugshot = 0
		MugShotStr = ""
	end
end 

	

NB.Threads.CreateLoop("SetMyMugShot",50,function()
	com.game.Client.Mugshot.Set()

	com.game.Client.Mugshot.Clear()
	
	
end)
end 