PlayerData = {}
ESX = nil
Busy = false
Water = false
prop = nil
PropCoords = nil
prop2 = nil
Prop2Coords = nil
startingPlanting = false
isPlanting = false
isFPlanting = false
Phase1 = false
Phase2 = false
Phase3 = false
PhaseF1 = false
PhaseF2 = false
PhaseF3 = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	while PlayerData.job == nil do
		Citizen.Wait(10)
	end
end)

function Draw3DText(x, y, z, text)
  local onScreen, _x, _y = World3dToScreen2d(x, y, z)
  local p = GetGameplayCamCoords()
  local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
  if onScreen then
  SetTextScale(0.25, 0.25)
  SetTextFont(6)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 255)
  SetTextDropshadow(0, 0, 0, 0, 255)
  SetTextEdge(2, 0, 0, 0, 150)
  SetTextDropShadow()
  SetTextOutline()
  SetTextEntry("STRING")
  SetTextCentre(1)
  AddTextComponentString(text)
  DrawText(_x,_y)
  end
end

AddEventHandler('onResourceStop', function()
  DeleteEntity(prop)
  DeleteEntity(prop2)
end)

------------------------------------------------------

----- MACHOS ----

RegisterNetEvent('slayn_owndrugplant:StartPlantingHighGrade')
AddEventHandler('slayn_owndrugplant:StartPlantingHighGrade', function()
  local inventory = ESX.GetPlayerData().inventory
  local count = 0
  local count2 = 0
  local count3 = 0
  local count4 = 0
  local count5 = 0
  for i=1, #inventory, 1 do
    if inventory[i].name == 'highgrademaleseed' then
      count = inventory[i].count
    end
    if inventory[i].name == 'plantpot' then
      count2 = inventory[i].count
    end
    if inventory[i].name == 'wateringcan' then
      count3 = inventory[i].count
    end
    if inventory[i].name == 'highgradefert' then
      count4 = inventory[i].count
    end
    if inventory[i].name == 'terra' then
      count5 = inventory[i].count
    end
  end
  if(count >= 1 and count2 >= 1 and count3 >= 1 and count4 >= 1 and count5 >= 1) and not startingPlanting then
    startingPlanting = true
    Phase1 = false
    local ped = GetPlayerPed(-1)
    local pedcoords = GetEntityCoords(ped)
    local x,y,z = table.unpack(pedcoords)
    RequestAnimDict("creatures@rottweiler@tricks@")
    while not HasAnimDictLoaded("creatures@rottweiler@tricks@") do
      Wait(10)
    end
    prop = CreateObjectNoOffset('bkr_prop_weed_01_small_01b', x, y, z+0.2,  true,  true, true)
    PropCoords = GetEntityCoords(prop)
    PlaceObjectOnGroundProperly(prop)
    FreezeEntityPosition(prop, true)
    exports['mythic_progbar']:Progress({
        name = "plantar_droga",
        duration = 15000,
        label = "A Preparar Plantação...",
        useWhileDead = false,
        canCancel = false, 
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },        
        animation = {
          animDict = "creatures@rottweiler@tricks@",
          anim = "petting_franklin",
          flags = 49,
        },  
    })
    Citizen.Wait(15000)
    StopAnimTask(ped,"creatures@rottweiler@tricks@","petting_franklin")
    isPlanting = true
    Phase1 = true
    TriggerServerEvent('slayn_owndrugplant:DeleteHighGrade', source)
  elseif startingPlanting or isPlanting then
    exports['mythic_notify']:SendAlert('error', 'Já Estás a Plantar.')
  else
    exports['mythic_notify']:SendAlert('error', 'Não Tens o Que é Preciso.')
  end
end)

RegisterNetEvent('slayn_owndrugplant:PlantingPhase1')
AddEventHandler('slayn_owndrugplant:PlantingPhase1', function()
  local inventory = ESX.GetPlayerData().inventory
  local count6 = 0
  local count7 = 0
  local chance = math.random(1,25)
  for i=1, #inventory, 1 do
    if inventory[i].name == 'wateringcan' then
      count6 = inventory[i].count
    end
    if inventory[i].name == 'highgradefert' then
      count7 = inventory[i].count
    end
  end
  if(count6 >= 1 and count7 >= 1)then
    Busy = true
    local ped = PlayerPedId()
    local pedcoords = GetEntityCoords(ped)
    RequestAnimDict("creatures@rottweiler@tricks@")
    while not HasAnimDictLoaded("creatures@rottweiler@tricks@") do
      Wait(10)
    end
    if not Water then
    TriggerServerEvent('slayn_owndrugplant:DeleteWater', source)
    exports['mythic_progbar']:Progress({
      name = "adicionar_agua",
      duration = 10000,
      label = "A Colocar Água Destilada...",
      useWhileDead = false,
      canCancel = false, 
      controlDisables = {
          disableMovement = true,
          disableCarMovement = true,
          disableMouse = false,
          disableCombat = true,
      },        
      animation = {
        animDict = "creatures@rottweiler@tricks@",
        anim = "petting_franklin",
        flags = 49,
      },  
    })
    Citizen.Wait(10000)
    if chance <= 10 then
      exports['mythic_notify']:SendAlert('inform', 'Meteste Pouca Quantidade de Água Destilada... Tenta Denovo...')
    elseif chance > 10 then
    exports['mythic_notify']:SendAlert('success', 'Adicionaste a Quantidade Certa de Água Destilada!')
    Water = true
    end
    Citizen.Wait(1000)
    TriggerServerEvent('slayn_owndrugplant:DeleteFertilizer', source)
    exports['mythic_progbar']:Progress({
      name = "adicionar_fertilizante",
      duration = 10000,
      label = "A Colocar Fertilizante...",
      useWhileDead = false,
      canCancel = false, 
      controlDisables = {
          disableMovement = true,
          disableCarMovement = true,
          disableMouse = false,
          disableCombat = true,
      },        
      animation = {
        animDict = "creatures@rottweiler@tricks@",
        anim = "petting_franklin",
        flags = 49,
      },  
    })
    Citizen.Wait(10000)
    if chance <= 10 then
      exports['mythic_notify']:SendAlert('inform', 'Meteste Pouca Quantidade de Fertilizante... Tenta Denovo...')
      Busy = false
    elseif chance > 10 then
    exports['mythic_notify']:SendAlert('success', 'Adicionaste a Quantidade Certa de Fertilizante!') 
    Citizen.Wait(1000)
    StopAnimTask(ped,"creatures@rottweiler@tricks@","petting_franklin")
    Phase1 = false
    Phase2 = true
    Busy = false
    Water = false
    end
    end
  else
    exports['mythic_notify']:SendAlert('error', 'Não Tens o Que é Preciso.')
    Busy = false
  end
end)

RegisterNetEvent('slayn_owndrugplant:PlantingPhase2')
AddEventHandler('slayn_owndrugplant:PlantingPhase2', function()
  local inventory = ESX.GetPlayerData().inventory
  local count8 = 0
  local chance = math.random(1,25)
  for i=1, #inventory, 1 do
    if inventory[i].name == 'wateringcan' then
      count8 = inventory[i].count
    end
  end
  if(count8 >= 1)then
    Busy = true
    local ped = PlayerPedId()
    local pedcoords = GetEntityCoords(ped)
    RequestAnimDict("creatures@rottweiler@tricks@")
    while not HasAnimDictLoaded("creatures@rottweiler@tricks@") do
      Wait(10)
    end
    TriggerServerEvent('slayn_owndrugplant:DeleteWater', source)
    exports['mythic_progbar']:Progress({
      name = "adicionar_agua",
      duration = 10000,
      label = "A Colocar Água Destilada...",
      useWhileDead = false,
      canCancel = false, 
      controlDisables = {
          disableMovement = true,
          disableCarMovement = true,
          disableMouse = false,
          disableCombat = true,
      },        
      animation = {
        animDict = "creatures@rottweiler@tricks@",
        anim = "petting_franklin",
        flags = 49,
      },  
    })
    Citizen.Wait(10000)
    if chance <= 10 then
      Busy = false
      exports['mythic_notify']:SendAlert('inform', 'Meteste Pouca Quantidade de Água Destilada... Tenta Denovo...')
    elseif chance > 10 then
      exports['mythic_notify']:SendAlert('success', 'Adicionaste a Quantidade Certa de Água Destilada!')
      Citizen.Wait(1000)
      StopAnimTask(ped,"creatures@rottweiler@tricks@","petting_franklin")
      Phase2 = false
      Phase3 = true
      Busy = false
    end
  else
    exports['mythic_notify']:SendAlert('error', 'Não Tens o Que é Preciso.')
    Busy = false
  end
end)

RegisterNetEvent('slayn_owndrugplant:PlantingPhase3')
AddEventHandler('slayn_owndrugplant:PlantingPhase3', function()
    local ped = PlayerPedId()
    local pedcoords = GetEntityCoords(ped)
    RequestAnimDict("creatures@rottweiler@tricks@")
    while not HasAnimDictLoaded("creatures@rottweiler@tricks@") do
      Wait(10)
    end
    Busy = true
    exports['mythic_progbar']:Progress({
      name = "colher_erva",
      duration = 17500,
      label = "A Colher...",
      useWhileDead = false,
      canCancel = false, 
      controlDisables = {
          disableMovement = true,
          disableCarMovement = true,
          disableMouse = false,
          disableCombat = true,
      },        
      animation = {
        animDict = "creatures@rottweiler@tricks@",
        anim = "petting_franklin",
        flags = 49,
      },  
    })
    Citizen.Wait(17500)
    TriggerServerEvent('slayn_owndrugplant:AddDrugsHighGrade', source)
    exports['mythic_notify']:SendAlert('success', 'Planta Colhida Com Sucesso.') 
    Phase3 = false   
    isPlanting = false
    DeleteEntity(prop)
    startingPlanting = false
    Busy = false
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(5)
    if isPlanting then
      local ped = GetPlayerPed(-1)
      local pedcoords = GetEntityCoords(ped)
      if GetDistanceBetweenCoords(pedcoords.x, pedcoords.y, pedcoords.z, PropCoords.x, PropCoords.y, PropCoords.z) < 1.5 then
        if Phase1 then
          Draw3DText(PropCoords.x, PropCoords.y, PropCoords.z, '~g~Macho'..'\n'..'~w~Fase: ~r~1/3'..'\n'..'~w~Precisa: ~b~Água Destilada ~w~& ~o~Fertilizante'..'\n'..'~r~[H] ~w~Avançar')
          if IsControlJustPressed(0, 74) then
            TriggerEvent('slayn_owndrugplant:PlantingPhase1')
          end
        elseif Phase2 then
          Draw3DText(PropCoords.x, PropCoords.y, PropCoords.z, '~g~Macho' .. '\n' .. '~w~Fase: ~r~2/3' .. '\n' .. '~w~Precisa: ~b~Água Destilada' .. '\n' .. '~r~[H] ~w~Avançar')
          if IsControlJustPressed(0, 74) then
            TriggerEvent('slayn_owndrugplant:PlantingPhase2')
          end
        elseif Phase3 then
          Draw3DText(PropCoords.x, PropCoords.y, PropCoords.z, '~g~Macho' .. '\n' .. '~w~Fase: ~r~3/3' .. '\n' .. '~g~Precisa De Ser Colhida' .. '\n' .. '~r~[H] ~w~Colher')
          if IsControlJustPressed(0, 74) then
            TriggerEvent('slayn_owndrugplant:PlantingPhase3')
          end
        else
          Citizen.Wait(500)
        end
      elseif GetDistanceBetweenCoords(pedcoords.x, pedcoords.y, pedcoords.z, PropCoords.x, PropCoords.y, PropCoords.z) > 2.5 then
        Citizen.Wait(500)
      end
    else
      Citizen.Wait(1500)
    end
  end
end)

------------------------------------------------------

----- FEMÊAS ----
RegisterNetEvent('slayn_owndrugplant:StartPlantingFHighGrade')
AddEventHandler('slayn_owndrugplant:StartPlantingFHighGrade', function()
  local inventory = ESX.GetPlayerData().inventory
  local count = 0
  local count2 = 0
  local count3 = 0
  local count4 = 0
  local count5 = 0
  for i=1, #inventory, 1 do
    if inventory[i].name == 'highgradefemaleseed' then
      count = inventory[i].count
    end
    if inventory[i].name == 'plantpot' then
      count2 = inventory[i].count
    end
    if inventory[i].name == 'wateringcan' then
      count3 = inventory[i].count
    end
    if inventory[i].name == 'highgradefert' then
      count4 = inventory[i].count
    end
    if inventory[i].name == 'terra' then
      count5 = inventory[i].count
    end
  end
  if(count >= 1 and count2 >= 1 and count3 >= 1 and count4 >= 1 and count5 >= 1) and not startingPlanting then
    startingPlanting = true
    local ped = GetPlayerPed(-1)
    local pedcoords = GetEntityCoords(ped)
    local x,y,z = table.unpack(pedcoords)
    RequestAnimDict("creatures@rottweiler@tricks@")
    while not HasAnimDictLoaded("creatures@rottweiler@tricks@") do
      Wait(10)
    end
    prop2 = CreateObjectNoOffset('bkr_prop_weed_01_small_01c', x, y, z+0.2,  true,  true, true)
    Prop2Coords = GetEntityCoords(prop2)
    PlaceObjectOnGroundProperly(prop2)
    FreezeEntityPosition(prop2, true)
    exports['mythic_progbar']:Progress({
        name = "plantar_droga",
        duration = 15000,
        label = "A Preparar Plantação...",
        useWhileDead = false,
        canCancel = false, 
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },        
        animation = {
          animDict = "creatures@rottweiler@tricks@",
          anim = "petting_franklin",
          flags = 49,
        },  
    })
    Citizen.Wait(15000)
    StopAnimTask(ped,"creatures@rottweiler@tricks@","petting_franklin")
    isFPlanting = true
    PhaseF1 = true
    TriggerServerEvent('slayn_owndrugplant:DeleteFHighGrade', source)
  elseif startingPlanting or isPlanting then
    exports['mythic_notify']:SendAlert('error', 'Já Estás a Plantar.')
  else
    exports['mythic_notify']:SendAlert('error', 'Não Tens o Que é Preciso.')
  end
end)

RegisterNetEvent('slayn_owndrugplant:PlantingFPhase1')
AddEventHandler('slayn_owndrugplant:PlantingFPhase1', function()
  local inventory = ESX.GetPlayerData().inventory
  local count6 = 0
  local count7 = 0
  local chance = math.random(1,25)
  for i=1, #inventory, 1 do
    if inventory[i].name == 'wateringcan' then
      count6 = inventory[i].count
    end
    if inventory[i].name == 'highgradefert' then
      count7 = inventory[i].count
    end
  end
  if(count6 >= 1 and count7 >= 1)then
    Busy = true
    local ped = PlayerPedId()
    local pedcoords = GetEntityCoords(ped)
    RequestAnimDict("creatures@rottweiler@tricks@")
    while not HasAnimDictLoaded("creatures@rottweiler@tricks@") do
      Wait(10)
    end
    if not Water then
    TriggerServerEvent('slayn_owndrugplant:DeleteWater', source)
    exports['mythic_progbar']:Progress({
      name = "adicionar_agua",
      duration = 10000,
      label = "A Colocar Água Destilada...",
      useWhileDead = false,
      canCancel = false, 
      controlDisables = {
          disableMovement = true,
          disableCarMovement = true,
          disableMouse = false,
          disableCombat = true,
      },        
      animation = {
        animDict = "creatures@rottweiler@tricks@",
        anim = "petting_franklin",
        flags = 49,
      },  
    })
    Citizen.Wait(10000)
    if chance <= 10 then
      exports['mythic_notify']:SendAlert('inform', 'Meteste Pouca Quantidade de Água Destilada... Tenta Denovo...')
      Busy = false
    elseif chance <= 15 then
      exports['mythic_notify']:SendAlert('error', 'Exageraste Na Quantidade de Água Destilada!')
      PhaseF1 = false
      isFPlanting = false
      DeleteEntity(prop2)
      exports['mythic_notify']:SendAlert('error', 'Mataste a Tua Planta Fêmea!')
      startingPlanting = false
      Busy = false
    elseif chance > 10 then
    exports['mythic_notify']:SendAlert('success', 'Adicionaste a Quantidade Certa de Água Destilada!')
    Water = true
    end
    Citizen.Wait(1000)
    TriggerServerEvent('slayn_owndrugplant:DeleteFertilizer', source)
    exports['mythic_progbar']:Progress({
      name = "adicionar_fertilizante",
      duration = 10000,
      label = "A Colocar Fertilizante...",
      useWhileDead = false,
      canCancel = false, 
      controlDisables = {
          disableMovement = true,
          disableCarMovement = true,
          disableMouse = false,
          disableCombat = true,
      },        
      animation = {
        animDict = "creatures@rottweiler@tricks@",
        anim = "petting_franklin",
        flags = 49,
      },  
    })
    Citizen.Wait(10000)
    if chance <= 10 then
      exports['mythic_notify']:SendAlert('inform', 'Meteste Pouca Quantidade de Fertilizante... Tenta Denovo...')
      Busy = false
    elseif chance <= 15 then
      exports['mythic_notify']:SendAlert('error', 'Exageraste Na Quantidade de Fertilizante!')
      PhaseF1 = false
      isFPlanting = false
      DeleteEntity(prop2)
      exports['mythic_notify']:SendAlert('error', 'Mataste a Tua Planta Fêmea!')
      startingPlanting = false
      Busy = false
    elseif chance > 10 then
    exports['mythic_notify']:SendAlert('success', 'Adicionaste a Quantidade Certa de Fertilizante!') 
    Citizen.Wait(1000)
    StopAnimTask(ped,"creatures@rottweiler@tricks@","petting_franklin")
    PhaseF1 = false
    PhaseF2 = true
    Busy = false
    Water = false
    end
    end
  else
    exports['mythic_notify']:SendAlert('error', 'Não Tens o Que é Preciso.')
    Busy = false
  end
end)

RegisterNetEvent('slayn_owndrugplant:PlantingFPhase2')
AddEventHandler('slayn_owndrugplant:PlantingFPhase2', function()
  local inventory = ESX.GetPlayerData().inventory
  local count8 = 0
  local chance = math.random(1,25)
  for i=1, #inventory, 1 do
    if inventory[i].name == 'wateringcan' then
      count8 = inventory[i].count
    end
  end
  if(count8 >= 1)then
    Busy = true
    local ped = PlayerPedId()
    local pedcoords = GetEntityCoords(ped)
    RequestAnimDict("creatures@rottweiler@tricks@")
    while not HasAnimDictLoaded("creatures@rottweiler@tricks@") do
      Wait(10)
    end
    TriggerServerEvent('slayn_owndrugplant:DeleteWater', source)
    exports['mythic_progbar']:Progress({
      name = "adicionar_agua",
      duration = 10000,
      label = "A Colocar Água Destilada...",
      useWhileDead = false,
      canCancel = false, 
      controlDisables = {
          disableMovement = true,
          disableCarMovement = true,
          disableMouse = false,
          disableCombat = true,
      },        
      animation = {
        animDict = "creatures@rottweiler@tricks@",
        anim = "petting_franklin",
        flags = 49,
      },  
    })
    Citizen.Wait(10000)
    if chance <= 10 then
      exports['mythic_notify']:SendAlert('inform', 'Meteste Pouca Quantidade de Água Destilada... Tenta Denovo...')
      Busy = false
    elseif chance <= 15 then
      exports['mythic_notify']:SendAlert('error', 'Exageraste Na Quantidade de Água Destilada!')
      PhaseF2 = false
      isFPlanting = false
      DeleteEntity(prop2)
      exports['mythic_notify']:SendAlert('error', 'Mataste a Tua Planta Fêmea!')
      startingPlanting = false
      Busy = false
    elseif chance > 10 then
      exports['mythic_notify']:SendAlert('success', 'Adicionaste a Quantidade Certa de Água Destilada!')
      Citizen.Wait(1000)
      StopAnimTask(ped,"creatures@rottweiler@tricks@","petting_franklin")
      PhaseF2 = false
      PhaseF3 = true
      Busy = false
    end
  else
    exports['mythic_notify']:SendAlert('error', 'Não Tens o Que é Preciso.')
    Busy = false
  end
end)

RegisterNetEvent('slayn_owndrugplant:PlantingFPhase3')
AddEventHandler('slayn_owndrugplant:PlantingFPhase3', function()
    local ped = PlayerPedId()
    local pedcoords = GetEntityCoords(ped)
    RequestAnimDict("creatures@rottweiler@tricks@")
    while not HasAnimDictLoaded("creatures@rottweiler@tricks@") do
      Wait(10)
    end
    Busy = true
    exports['mythic_progbar']:Progress({
      name = "adicionar_agua",
      duration = 17500,
      label = "A Colher...",
      useWhileDead = false,
      canCancel = false, 
      controlDisables = {
          disableMovement = true,
          disableCarMovement = true,
          disableMouse = false,
          disableCombat = true,
      },        
      animation = {
        animDict = "creatures@rottweiler@tricks@",
        anim = "petting_franklin",
        flags = 49,
      },  
    })
    Citizen.Wait(17500)
    TriggerServerEvent('slayn_owndrugplant:AddDrugsFHighGrade', source)
    exports['mythic_notify']:SendAlert('success', 'Planta Colhida Com Sucesso.') 
    PhaseF3 = false   
    isPlanting = false
    DeleteEntity(prop2)
    startingPlanting = false
    Busy = false
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(5)
    if isFPlanting then
      local ped = GetPlayerPed(-1)
      local pedcoords = GetEntityCoords(ped)
      if GetDistanceBetweenCoords(pedcoords.x, pedcoords.y, pedcoords.z, Prop2Coords.x, Prop2Coords.y, Prop2Coords.z) < 1.5 then
        if PhaseF1 then
          Draw3DText(Prop2Coords.x, Prop2Coords.y, Prop2Coords.z, '~g~Fêmea'..'\n'..'~w~Fase: ~r~1/3'..'\n'..'~w~Precisa: ~b~Água Destilada ~w~& ~o~Fertilizante'..'\n'..'~r~[H] ~w~Avançar')
          if IsControlJustPressed(0, 74) then
            TriggerEvent('slayn_owndrugplant:PlantingFPhase1')
          end
        elseif PhaseF2 then
          Draw3DText(Prop2Coords.x, Prop2Coords.y, Prop2Coords.z, '~g~Fêmea' .. '\n' .. '~w~Fase: ~r~2/3' .. '\n' .. '~w~Precisa: ~b~Água Destilada' .. '\n' .. '~r~[H] ~w~Avançar')
          if IsControlJustPressed(0, 74) then
            TriggerEvent('slayn_owndrugplant:PlantingFPhase2')
          end
        elseif PhaseF3 then
          Draw3DText(Prop2Coords.x, Prop2Coords.y, Prop2Coords.z, '~g~Fêmea' .. '\n' .. '~w~Fase: ~r~3/3' .. '\n' .. '~g~Precisa De Ser Colhida' .. '\n' .. '~r~[H] ~w~Colher')
          if IsControlJustPressed(0, 74) then
            TriggerEvent('slayn_owndrugplant:PlantingFPhase3')
          end
        else
          Citizen.Wait(500)
        end
      elseif GetDistanceBetweenCoords(pedcoords.x, pedcoords.y, pedcoords.z, Prop2Coords.x, Prop2Coords.y, Prop2Coords.z) > 2.5 then
        Citizen.Wait(500)
      end
    else
      Citizen.Wait(1500)
    end
  end
end)