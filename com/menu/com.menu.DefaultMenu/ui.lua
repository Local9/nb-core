if IsClient() then 
	local ct = CreateThread
	com.menu.DefaultMenu.UI.RenderStop = function()
		print('renderStop')
	end 
	com.menu.DefaultMenu.UI.Render = function(simplymenu,isUpdate,slot)
		print("Render")
		print(json.encode(simplymenu))
		
	end

end 
