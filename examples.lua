if IsShared() then 
	CreateThread(function()

	end)
end
if IsServer() then 
	CreateThread(function()
		NB.RegisterServerCallback("NB:test",function(playerId,cb)
			cb("bad",9993.23332321,"a")
			
		end )
	end)
end 
if IsClient() then 
	CreateThread(function()
		--[=[

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

		--]=]
		NB.TriggerServerCallback('NB:test',function (...)
			print(...)
		end)
	end)
end 