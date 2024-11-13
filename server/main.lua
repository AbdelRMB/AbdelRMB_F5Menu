--		  █████╗ ██████╗ ██████╗ ███████╗██╗     ██████╗ ███╗   ███╗██████╗
--		 ██╔══██╗██╔══██╗██╔══██╗██╔════╝██║     ██╔══██╗████╗ ████║██╔══██╗
--		 ███████║██████╔╝██║  ██║█████╗  ██║     ██████╔╝██╔████╔██║██████╔╝
--		 ██╔══██║██╔══██╗██║  ██║██╔══╝  ██║     ██╔══██╗██║╚██╔╝██║██╔══██╗
--		 ██║  ██║██████╔╝██████╔╝███████╗███████╗██║  ██║██║ ╚═╝ ██║██████╔╝
--		 ╚═╝  ╚═╝╚═════╝ ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═════╝

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

ESX.RegisterServerCallback('f5menu:getPlayerBills', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(bills)
        cb(bills)
    end)
end)


RegisterNetEvent('f5menu:payBill')
AddEventHandler('f5menu:payBill', function(billId, amount, societyName)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then return end

    if xPlayer.getAccount('bank').money >= amount then
        xPlayer.removeAccountMoney('bank', amount)

        MySQL.Async.execute('DELETE FROM billing WHERE id = @id', { ['@id'] = billId }, function(rowsChanged)
            if rowsChanged > 0 then
                if societyName and societyName ~= '' then
                    TriggerEvent('esx_addonaccount:getSharedAccount', societyName, function(societyAccount)
                        if societyAccount then
                            societyAccount.addMoney(amount)

                            MySQL.Async.execute('UPDATE addon_account_data SET money = money + @amount WHERE account_name = @societyName', {
                                ['@amount'] = amount,
                                ['@societyName'] = societyName
                            }, function(affectedRows)
                                if affectedRows > 0 then
                                    TriggerClientEvent('AbdelRMB:Notify', _source, 'Facture payée !', 'success', 5000)

                                    local playerName = xPlayer.getName()
                                    for _, playerId in ipairs(GetPlayers()) do
                                        local targetPlayer = ESX.GetPlayerFromId(playerId)
                                        if targetPlayer and targetPlayer.job.name == 'bennys' then
                                            TriggerClientEvent('AbdelRMB:Notify', playerId, "Une facture de $" .. amount .. " vient d'être payée par " .. playerName, 'info', 5000)
                                        end
                                    end
                                else
                                    TriggerClientEvent('AbdelRMB:Notify', _source, 'Erreur lors de la mise à jour du solde !', 'error', 5000)
                                end
                            end)
                        else
                            TriggerClientEvent('AbdelRMB:Notify', _source, 'Compte de la société introuvable !', 'error', 5000)
                        end
                    end)
                else
                    TriggerClientEvent('AbdelRMB:Notify', _source, 'Facture payée avec succès !', 'success', 5000)
                end
                TriggerClientEvent('f5menu:updatePlayerBillsMenu', _source)
            else
                TriggerClientEvent('AbdelRMB:Notify', _source, 'Erreur lors de la suppression de la facture.', 'error', 5000)
            end
        end)
    else
        TriggerClientEvent('AbdelRMB:Notify', _source, 'Fonds insuffisants !', 'error', 5000)
    end
end)

