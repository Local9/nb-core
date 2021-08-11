local Debug = {}
com.lua.utils.Debug = Debug
Debug.DrawText = function(text)
	SetTextScale(0.5, 0.5)
	SetTextFont(0)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.8, 0.8)
	ClearDrawOrigin()
end
