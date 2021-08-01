CreateThread(function()

end)



CreateThread(function()
    NB.TriggerServerCallback('servertime',function (...)
        print("Server Time",...)
    end)
end)