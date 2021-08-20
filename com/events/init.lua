Events = {}
Events.Event = {}
this = Events

function Say(playerid,str,saybywho)
    TriggerClientEvent("CreateSay",playerid,str,saybywho)
end 

function Select(playerid,...)
    TriggerClientEvent("CreateSelection",playerid,...)
end 

function StartEvent(eventid,playerid)
    this.Event[eventid](playerid)
end 

AddEventHandler('nb-core:StartEvent', function(eventid)
	StartEvent(eventid)
end)

exports('StartEvent',function(eventid)
    StartEvent(eventid)
end)
