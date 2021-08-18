if IsClient() then 
	CreateThread(function()
		local menu = NBMenu.RegisterPauseMenu("TTitle","DDESC","fishing",
			{
				{label="Apple",value="Apple"},
				{label="选择水果",type="slider",options={"apple","banana","orange"},description="select your favour"},
				{label="Apple123",value="Apple123",description="good health",setter="X"},--scroll and selections > 7 
				{label="Apple123",value="Apple123",setter="XY"},--scroll and selections > 7 
				{label="Apple123",value="Apple123",setter="XY"},
				{label="Apple123",value="Apple123",setter="XY"},
				{label="Apple123",value="Apple123",setter="XY"},
				{label="Apple123",value="Apple123",setter="XY"},
				{label="保存",value="Save",type="footer"},
			},
			function(result)
				print("OnSubmit","value:"..result.current.value)
			end,
			function(result)
				--CloseMenu(menuHandle)
				print("OnCancel","value:"..result.current.value)
			end,
			function(result)
				print("OnChange","value:"..result.current.value)
			end,
			function()
				print("OnClose")
			end
		)
		
		menu.open()
		Wait(3000)
		menu.close()
		--NBMenu.SetMenuAsNoLongerNeeded(menuHandle)
		
		
		
	end)
	

end 