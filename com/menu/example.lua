if IsClient() then 
CreateThread(function()
	Wait(2000)
		local elements = {}
		local HairColors = {}
		for i=0,GetNumHairColors() do 
			PauseMenu.SetColorData(7,i,GetPedHairRgbColor(i))
			table.insert(HairColors,{GetPedHairRgbColor(i)})
		end 
		local Salle = {
			{label="Apple",value="Apple"},
			{label="选择水果",type="slider",options={"apple","banana","orange"},description="select your favour"},
			{label="Apple123",value="Apple123",description="good health",setter="X"},
			{label="Apple123",value="Apple123",setter="XY"},
			{label="Apple123",value="Apple123",setter="XY"},
			{label="Apple123",value="Apple123",setter="XY"},
			{label="Apple123",value="Apple123",setter="XY"},
			{label="Apple1234",type="slider",options=HairColors,setter="COLOR"},
			{label="保存",value="Save",type="footer"},
		}
		NB.MenuFramework.CloseAll()
		NB.MenuFramework.Open(
			'PauseMenu', GetCurrentResourceName(), 'strip',
			{
				title  = 'Position Menu',
				description = "MENU DESCRIPTION",
				style = "scroll_color", -- 0: list menu  |  1: link-pad rolling list menu  |  2:  bar menu 142561   | 3:  pad menu   | 4: skillpoint menu  | 5:skilldata menu | 6: link-color-list menu |  7:color menu 
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