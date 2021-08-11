local Debug = {}
com.lua.utils.Debug = Debug
com.lua.utils.Debug.DrawText2DText = {}
Debug.DrawText2D = function(text,cb)
	com.lua.utils.Debug.DrawText2DText[text] = true
	local breaker = function()
		com.lua.utils.Debug.DrawText2DText[text] = false 
	end 
	local runner = function() 
		CreateThread(function()
			while true do Wait(0) 
				if com.lua.utils.Debug.DrawText2DText[text] then 
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
				else 
					break  
				end 
			end 
		end)
	end 
	cb(runner , breaker)
end
--[=[
Debug.DrawText2D("hi",function(draw,endit)
	draw()
end)
--]=]