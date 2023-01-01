ESX = nil
Citizen.CreateThread(function()
      while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(100)
      end
end)

napadzior = false
blips = {}

Citizen.CreateThread(function()
    while true and not napadzior do
        
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        for i=1, #Config.Locations, 1 do
            local dystans = #(coords - Config.Locations[i])

            if dystans <= 3 then
                ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~ aby obrabować bankomat')
                if IsControlPressed(0, 38) then
                    napadzior = true
                    TriggerServerEvent('fajnyTrigger', GetEntityCoords(PlayerPedId()))
                end
            end
        end

        Citizen.Wait(70)
    end
end)

RegisterNetEvent('JebacKurwyPolicyjne')
AddEventHandler('JebacKurwyPolicyjne', function(kordy, id)
    ESX.ShowNotification("~w~Rozpoczęto ~r~napad ~w~na ~o~bankomat")
    local b = AddBlipForCoord(kordy)
    SetBlipSprite(b, Config.Blip.id)
    SetBlipDisplay(b, 4)
    SetBlipScale(b, 1.0)
    SetBlipColour(b, Config.Blip.colour)
    SetBlipAsShortRange(b, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Blip.title)
    EndTextCommandSetBlipName(b)
    blips[id] = b
end)

RegisterNetEvent('napadSkonczony')
AddEventHandler('napadSkonczony', function()
    print('chore')
    napadzior = false
end)

RegisterNetEvent('typekSkonczyl')
AddEventHandler('typekSkonczyl', function(id)
    RemoveBlip(blips[id])
    blips[id] = nil
end)