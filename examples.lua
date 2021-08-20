if IsShared() then 

end
if IsServer() then 

end 
if IsClient() then 
--[=[
CreateThread(function()
	for i=1,21 do 
		NB.CreateLoad("model","dlc_sol",function(handle)
			print('model here',i,handle)
		end )
		NB.CreateLoad("texture","dlc_sol",function(handle)
			print('texture here',i,handle)
		end )
		NB.CreateLoad("scaleform","dlc_sol",function(handle)
			print('scaleform here',i,handle)
		end )
	end 
end)
--]=]
end 