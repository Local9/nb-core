local Debug = {}
com.lua.utils.Debug = Debug
Debug.DrawText2D = function(...)
	SetScriptGfxDrawBehindPausemenu(true)
	local args = {...}
	local length = #args 
	SetTextScale(0.5, 0.5)
	SetTextFont(0)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
	for i,v in pairs(args) do 
		v = tostring(v)
	end 
	local text = table.concat(args,",")

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.8, 0.8)
	
	ClearDrawOrigin()

	SetScriptGfxDrawBehindPausemenu(false)
end
Debug.DrawTextIndex = 0
Debug.DrawText = function(...)
	Debug.DrawTextIndex = Debug.DrawTextIndex + 1
	local nowindex = Debug.DrawTextIndex
	local args = {...}
	CreateThread(function()
		while Debug.DrawTextIndex == nowindex do Wait(0)
			Debug.DrawText2D(table.unpack(args))	
		end 
	end)
end