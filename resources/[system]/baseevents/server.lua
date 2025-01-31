RegisterServerEvent('baseevents:onPlayerDied')
RegisterServerEvent('baseevents:onPlayerKilled')
RegisterServerEvent('baseevents:onPlayerWasted')
RegisterServerEvent('baseevents:enteringVehicle')
RegisterServerEvent('baseevents:enteringAborted')
RegisterServerEvent('baseevents:enteredVehicle')
RegisterServerEvent('baseevents:leftVehicle')

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('baseevents:onPlayerKilled', function(killedBy, data)
	local victim = source
    print(victim .. " was killed by " .. killedBy)

    while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

    if (killedBy > -1) then
        local killerPlayer = ESX.GetPlayerFromId(killedBy)
        TriggerClientEvent('chatMessage', victim, 'SYSTEM', { 0, 0, 0 }, 'You were killed by ' .. killerPlayer.name)

        local victimPlayer = ESX.GetPlayerFromId(victim)
        TriggerClientEvent('chatMessage', killedBy, 'SYSTEM', { 0, 0, 0 }, 'You just killed ' .. victimPlayer.name)
        -- PerformHttpRequest(GetConvar('discord_endpoint', ''), function(err, text, headers) end, 'POST', json.encode({username = "Kill Watchdog", content = killString }), { ['Content-Type'] = 'application/json' })
    end

	RconLog({msgType = 'playerKilled', victim = victim, attacker = killedBy, data = data})
end)

AddEventHandler('baseevents:onPlayerDied', function(killedBy, pos)
	local victim = source

	RconLog({msgType = 'playerDied', victim = victim, attackerType = killedBy, pos = pos})
end)