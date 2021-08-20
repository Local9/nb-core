if IsShared() then 

end
if IsServer() then 

end 
if IsClient() then 
--[=[
CreateThread(function()
	for i=1,21 do 
		NB.Stream("model","dlc_sol",function(handle)
			print('model here',i,handle)
		end )
		NB.Stream("texture","dlc_sol",function(handle)
			print('texture here',i,handle)
		end )
		NB.Stream("scaleform","dlc_sol",function(handle)
			print('scaleform here',i,handle)
		end )
	end 
end)
--]=]
end 