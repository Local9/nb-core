if IsClient() then 
	local open = function(invoking,index, data) --button = data.elements
		print(invoking,index,json.encode(data))
	end
	local close = function() --button = data.elements
		print("close")
	end
	
	com.menu.RegisterType("default", open, close)
	
	
end 