if IsClient() then 
CreateThread(function()
	local elements = {}
	local Salle = {
		{label="Apple",value="Apple"},
		{label="选择水果",type="slider",options={"apple","banana","orange"}},
		{label="Apple123",value="Apple123"},
		{label="Apple123",value="Apple123"},
		{label="Apple123",value="Apple123"},
		{label="Apple123",value="Apple123"},
		{label="Apple123",value="Apple123"},
		{label="Apple123",value="Apple123"},
		{label="Apple123",value="Apple123"},
		{label="Apple123",value="Apple123"},
		{label="Apple123",value="Apple123"},
		{label="Apple123",value="Apple123"},
		{label="保存",value="Save",type="footer"},
	}
	NB.MenuFramework.CloseAll()
	NB.MenuFramework.Open(
		'PauseMenu', GetCurrentResourceName(), 'strip',
		{
			title  = 'Position Menu',
			description = "MENU DESCRIPTION",
			style = 0,
			elements = Salle
		},
		function(data, menu)
			print("result open",data.current.value)
			--menu.close()
			--NB.Utils.Debug.DrawText("Open",data.current.value)
		end,
		function(data, menu)
			print("result cancel")
			--NB.Utils.Debug.DrawText("Cancel")
			menu.close()
		end
		,
		function(data, menu)
			print("result change",data.current.value)
			--NB.Utils.Debug.DrawText("Change",data.current.value)
			
		end
		,
		function()
			print("result close")
			--NB.Utils.Debug.DrawText("Close")
		end
	)
end)
end 