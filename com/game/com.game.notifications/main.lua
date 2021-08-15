local Notifications = {} -- https://github.com/negbook/notifications
com.game.Client.Notifications = Notifications
Notifications.ShowNotificatioMessagetext = function(nameStr, subtitleStr, crewPackedStr,bodyStr, txd, txn, iconEnum, icon2Enum, iTextColor,speed)
    local t1 = RequestStreamedTextureDict(txd)
    while not HasStreamedTextureDictLoaded(txd) do
        Citizen.Wait(0)
    end
    speed = speed or 1.0
    if logInPauseMenu == nil then logInPauseMenu = 1 end 
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(bodyStr)
    EndTextCommandThefeedPostMessagetextWithCrewTagAndAdditionalIcon( txd, txn, false,iconEnum,nameStr,subtitleStr,speed,crewPackedStr,icon2Enum,iTextColor)
end
Notifications.ShowNotificatioStats = function(statTitleStr, statBodyStr, oldProgress,newProgress, txd, txn)
    local t1 = RequestStreamedTextureDict(txd)
    while not HasStreamedTextureDictLoaded(txd) do
        Citizen.Wait(0)
    end
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(statBodyStr)
    AddTextEntry(statTitleStr,statTitleStr)
    EndTextCommandThefeedPostStats(statTitleStr, 0, newProgress, oldProgress, 0, txd, txn)
end
Notifications.ShowNotificationTicker = function(msg)
    logInPauseMenu = 1
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandThefeedPostTicker(0,logInPauseMenu)
end
Notifications.ShowNotificationAward = function( titleStr,subtitle,xp, txd, txn, colourEnum)
    local t1 = RequestStreamedTextureDict(txd)
    while not HasStreamedTextureDictLoaded(txd) do
        Citizen.Wait(0)
    end
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(subtitle)
    AddTextEntry(titleStr,titleStr)
    EndTextCommandThefeedPostAward(txd, txn, xp, colourEnum, titleStr)
end
Notifications.ShowNotificationUnlock = function(title,iconIndex,subtitle,colourEnum)
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(subtitle)
    if not colourEnum then colourEnum = 0 end 
    EndTextCommandThefeedPostUnlockTuWithColor(title,iconIndex,subtitle,false,colourEnum,true)
end
Notifications.ShowNotificatioCrewRankup = function(chTitle, chSubitle, chTXD, chTXN)
    local t1 = RequestStreamedTextureDict(chTXD)
    while not HasStreamedTextureDictLoaded(chTXD) do
        Citizen.Wait(0)
    end
    if logInPauseMenu == nil then logInPauseMenu = 1 end 
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(chTitle)
    AddTextEntry(chSubitle,chSubitle)
    EndTextCommandThefeedPostCrewRankup(chSubitle, chTXD, chTXN, 0)
end
Notifications.ShowNotificationVersus = function(TXD1,TXN1,int1,TXD2,TXN2,int2)
    local t1,t2 = RequestStreamedTextureDict(TXD1),RequestStreamedTextureDict(TXD2)
    while not (HasStreamedTextureDictLoaded(TXD1) and HasStreamedTextureDictLoaded(TXD2)) do
        Citizen.Wait(0)
    end
    BeginTextCommandThefeedPost('STRING')
    EndTextCommandThefeedPostVersusTu(TXD1,TXN1,int1,TXD2,TXN2,int2)
end
Notifications.ShowNotificatioReplay = function(sSubtitle, Icon)
    local eType = 1 
    BeginTextCommandThefeedPost("STRING")
    if type(Icon) == "number" then 
        EndTextCommandThefeedPostReplayIcon(eType,Icon,sSubtitle)
    else 
        EndTextCommandThefeedPostReplayInput(eType,Icon,sSubtitle)
    end 
end