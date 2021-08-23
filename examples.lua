if IsShared() then 
	CreateThread(function()

	end)
end
if IsServer() then 
	--[=[
	CreateThread(function()
		NB.RegisterServerCallback("NB:test",function(playerId,cb)
			cb("bad",9993.23332321,"a")
			
		end )
	end)
	--]=]
	--[=[
	CreateThread(function() 
		while true do Wait(1000)
			NB.TriggerClientCallback(2,"test",function(r)
				print(r)
			end )
		end 
	end )
	--]=]

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
		--[=[
		NB.TriggerServerCallback('NB:test',function (...)
			print(...)
		end)
		--]=]
		--[=[
		NB.RegisterClientCallback("test",function(cb)
			cb(123)
		end)
		--]=]
	end)
end 