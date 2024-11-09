ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback('f5menu:getPlayerInfo', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local accounts = xPlayer.getAccounts(true)

        local playerData = {
            firstname = xPlayer.get('firstName'),
            lastname = xPlayer.get('lastName'),
            job = xPlayer.job.name,
            jobGrade = xPlayer.job.grade,
            accounts = accounts  
        }
        cb(playerData)
    else
        cb(nil)
    end
end)
