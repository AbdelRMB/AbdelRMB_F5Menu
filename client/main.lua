--		  █████╗ ██████╗ ██████╗ ███████╗██╗     ██████╗ ███╗   ███╗██████╗
--		 ██╔══██╗██╔══██╗██╔══██╗██╔════╝██║     ██╔══██╗████╗ ████║██╔══██╗
--		 ███████║██████╔╝██║  ██║█████╗  ██║     ██████╔╝██╔████╔██║██████╔╝
--		 ██╔══██║██╔══██╗██║  ██║██╔══╝  ██║     ██╔══██╗██║╚██╔╝██║██╔══██╗
--		 ██║  ██║██████╔╝██████╔╝███████╗███████╗██║  ██║██║ ╚═╝ ██║██████╔╝
--		 ╚═╝  ╚═╝╚═════╝ ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═════╝

ESX = exports["es_extended"]:getSharedObject()

local playerId = GetPlayerServerId(PlayerId())
local playerName = GetPlayerName(PlayerId())
local job = "Inconnu"
local cash = 0
local bank = 0
local dirtyMoney = 0
local AbdelRMBUI = exports['AbdelRMBUI']:GetAbdelRMBUI()

function fetchPlayerInfo(callback)
    ESX.TriggerServerCallback('f5menu:getPlayerInfo', function(user)
        if user then
            playerName = user.firstname .. " " .. user.lastname
            job = user.job .. " (" .. user.jobGrade .. ")"
            
            local accounts = user.accounts
            if accounts then
                cash = accounts.money or 0
                bank = accounts.bank or 0
                dirtyMoney = accounts.black_money or 0
            else
                cash, bank, dirtyMoney = 0, 0, 0
            end
        end
        
        if callback then callback() end
    end)
end

function fetchPlayerBills(callback)
    ESX.TriggerServerCallback('f5menu:getPlayerBills', function(billsData)
        bills = billsData or {}
        if callback then callback() end
    end)
end


AbdelRMBUI.CreateMenu("F5", "mainMenu", "")
AbdelRMBUI.CreateMenu("F5", "playerInfo", "Informations du Joueur", "mainMenu")
AbdelRMBUI.CreateMenu("F5", "playerMoney", "Portefeuille du Joueur", "mainMenu")
AbdelRMBUI.CreateMenu("F5", "playerBills", "Factures", "mainMenu")

AbdelRMBUI.AddMenuItem("F5_mainMenu", "Informations", function()
    fetchPlayerInfo()
    updatePlayerInfoMenu()
    AbdelRMBUI.OpenMenu("F5", "playerInfo")
end)

AbdelRMBUI.AddMenuItem("F5_mainMenu", "Portefeuille", function()
    fetchPlayerInfo()
    updatePlayerMoneyMenu()
    AbdelRMBUI.OpenMenu("F5", "playerMoney")
end)

AbdelRMBUI.AddMenuItem("F5_mainMenu", "Factures", function()
    fetchPlayerBills(function()
        updatePlayerBillsMenu()
        AbdelRMBUI.OpenMenu("F5", "playerBills")
    end)
end)

AbdelRMBUI.AddMenuItem("F5_mainMenu", "Quitter le menu", function()
    AbdelRMBUI.CloseMenu("F5", "mainMenu")
end)

function updatePlayerInfoMenu()
    AbdelRMBUI.ClearMenu("F5_playerInfo")
    AbdelRMBUI.AddMenuItem("F5_playerInfo", "Nom: " .. playerName)
    AbdelRMBUI.AddMenuItem("F5_playerInfo", "ID: " .. playerId)
    AbdelRMBUI.AddMenuItem("F5_playerInfo", "Job: " .. job)
    AbdelRMBUI.AddMenuItem("F5_playerInfo", "Retour au Menu Principal", function()
        AbdelRMBUI.OpenMenu("F5", "mainMenu")
    end)
end

function updatePlayerMoneyMenu()
    AbdelRMBUI.ClearMenu("F5_playerMoney")
    AbdelRMBUI.AddMenuItem("F5_playerMoney", "Espèces: $" .. cash)
    AbdelRMBUI.AddMenuItem("F5_playerMoney", "Banque: $" .. bank)
    AbdelRMBUI.AddMenuItem("F5_playerMoney", "Argent sale: $" .. dirtyMoney)
    AbdelRMBUI.AddMenuItem("F5_playerMoney", "Retour au Menu Principal", function()
        AbdelRMBUI.OpenMenu("F5", "mainMenu")
    end)
end


function updatePlayerBillsMenu()
    AbdelRMBUI.ClearMenu("F5_playerBills")

    if #bills > 0 then
        for _, bill in ipairs(bills) do
            local label = bill.label .. " - $" .. bill.amount
            AbdelRMBUI.AddMenuItem("F5_playerBills", label, function()
                TriggerServerEvent('f5menu:payBill', bill.id, bill.amount, bill.target)
                fetchPlayerBills(updatePlayerBillsMenu)
                AbdelRMBUI.CloseMenu("F5", "playerBills")
            end)
        end
    else
        AbdelRMBUI.AddMenuItem("F5_playerBills", "Aucune facture disponible.")
    end

    AbdelRMBUI.AddMenuItem("F5_playerBills", "Retour au Menu Principal", function()
        AbdelRMBUI.OpenMenu("F5", "mainMenu")
    end)
end



function openF5Menu()
    fetchPlayerInfo(function()
        updatePlayerInfoMenu()
        updatePlayerMoneyMenu()
        AbdelRMBUI.OpenMenu("F5", "mainMenu")
    end)
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustPressed(1, 166) then
            openF5Menu()
        end
    end
end)