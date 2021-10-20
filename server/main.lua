ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj
end)

ESX.RegisterUsableItem('highgrademaleseed', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('slayn_owndrugplant:StartPlantingHighGrade', source)
end)

ESX.RegisterUsableItem('highgradefemaleseed', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('slayn_owndrugplant:StartPlantingFHighGrade', source)
end)

RegisterNetEvent('slayn_owndrugplant:DeleteHighGrade')
AddEventHandler('slayn_owndrugplant:DeleteHighGrade', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('highgrademaleseed', 1)
    xPlayer.removeInventoryItem('plantpot', 1)
    xPlayer.removeInventoryItem('wateringcan', 1)
    xPlayer.removeInventoryItem('highgradefert', 1)
    xPlayer.removeInventoryItem('terra', 1)
end)

RegisterNetEvent('slayn_owndrugplant:AddDrugsHighGrade')
AddEventHandler('slayn_owndrugplant:AddDrugsHighGrade', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addInventoryItem('highgradefemaleseed', 2)
end)

RegisterNetEvent('slayn_owndrugplant:DeleteFHighGrade')
AddEventHandler('slayn_owndrugplant:DeleteFHighGrade', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('highgradefemaleseed', 1)
    xPlayer.removeInventoryItem('plantpot', 1)
    xPlayer.removeInventoryItem('wateringcan', 1)
    xPlayer.removeInventoryItem('highgradefert', 1)
    xPlayer.removeInventoryItem('terra', 1)
end)

RegisterNetEvent('slayn_owndrugplant:AddDrugsFHighGrade')
AddEventHandler('slayn_owndrugplant:AddDrugsFHighGrade', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local quantidade = math.random(8,15)
    xPlayer.addInventoryItem('trimmedweed', quantidade)
end)

RegisterNetEvent('slayn_owndrugplant:DeleteWater')
AddEventHandler('slayn_owndrugplant:DeleteWater', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('wateringcan', 1)
end)

RegisterNetEvent('slayn_owndrugplant:DeleteFertilizer')
AddEventHandler('slayn_owndrugplant:DeleteFertilizer', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('highgradefert', 1)
end)