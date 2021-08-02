NB = {}

local function GetObject()
	return NB
end
AddEventHandler('NB:GetObject', function(cb)
	cb(GetObject())
end)

