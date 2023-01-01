ESX = nil
robbing = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('fajnyTrigger')
AddEventHandler('fajnyTrigger', function(kordy)
    local _source = source

    if not robbing[_source] then
        robbing[_source] = true
        local xPlayers = ESX.GetPlayers()
        local psy = {}
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            local praca = xPlayer.getJob()
            
            if praca.name == 'police' then
                table.insert(psy, xPlayers[i])
            end
        end

        if #psy >= Config.MinPolicji then
            FreezeEntityPosition(GetPlayerPed(_source), true)
            local xPlayer = ESX.GetPlayerFromId(_source)
            xPlayer.showNotification('Okradasz bankomat poczekaj 120 sekund!')
            xPlayer.showNotification('Uwaga policja dostała informacje o napadzie!')

            for i=1, #psy, 1 do
                TriggerClientEvent('JebacKurwyPolicyjne', psy[i], kordy, _source)
            end

            Wait(Config.Czas) -- czekaj kurwa 120 sekund chamie

            math.randomseed(os.time())
            local kasa = math.random(Config.MinWyplata, Config.MaxWyplata)
            xPlayer.addMoney(kasa)
            xPlayer.showNotification(string.format('Udało ci się otworzyć bankomat i znalazłeś %s gotówki', kasa))
            FreezeEntityPosition(GetPlayerPed(_source), false)
            TriggerClientEvent('napadSkonczony', _source)

            for i=1, #psy, 1 do
                TriggerClientEvent('typekSkonczyl', psy[i], _source)
            end
        else
            local xPlayer = ESX.GetPlayerFromId(_source)
            xPlayer.showNotification('Za mało policjantów na służbie jełopie')
            TriggerClientEvent('napadSkonczony', _source)
        end

        robbing[_source] = false
    end
end)