Events = {}
Events.Event = {}
this = Events

function Say(playerid,str,saybywho)
    NB.TriggerClientEvent("CreateSay",playerid,str,saybywho)
end 

function Select(playerid,...)
    NB.TriggerClientEvent("CreateSelection",playerid,...)
end 

function StartEvent(eventid,playerid)
    this.Event[eventid](playerid)
end 

NB.AddEventHandler('nb-core:StartEvent', function(eventid)
	StartEvent(eventid)
end)

exports('StartEvent',function(eventid)
    StartEvent(eventid)
end)
