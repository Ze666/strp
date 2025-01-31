local shoppingList = {
    [1507916787] = { name = "Picador", costs = 160, model = "picador", damageMultiplier = 1  },
    [-1150599089] = { name = "Primo", costs = 160, model = "primo", damageMultiplier = 1 },
    [-1130810103] = { name = "Dilettante", costs = 210, model = "dilettante", damageMultiplier = 1 },
    [-1800170043] = { name = "Gauntlet", costs = 370, model = "gauntlet", damageMultiplier = 3 },
    [486987393] = { name = "Huntley S", costs = 560, model = "huntley", damageMultiplier = 6 },
    [-682211828] = { name = "Buccaneer", costs = 270, model = "buccaneer", damageMultiplier = 3 },
    [1269098716] = { name = "Landstalker", costs = 360, model = "landstalker", damageMultiplier = 4 },
    [873639469] = { name = "Sentinel", costs = 350, model = "sentinel2", damageMultiplier = 4 },
    [1349725314] = { name = "Sentinel XS", costs = 360, model = "sentinel", damageMultiplier = 3 },
    [-304802106] = { name = "Buffalo", costs = 280, model = "buffalo", damageMultiplier = 3 },
    [-5153954] = { name = "Exemplar", costs = 550, model = "exemplar", damageMultiplier = 8 },
    [767087018] = { name = "Alpha", costs = 530, model = "alpha", damageMultiplier = 7 },
    [-1041692462] = { name = "Banshee", costs = 530, model = "banshee", damageMultiplier = 6 },
    [1723137093] = { name = "Stratum", costs = 180, model = "stratum", damageMultiplier = 1 },
    [-1685021548] = { name = "Sabre Turbo", costs = 220, model = "sabregt", damageMultiplier = 2 },
    [841808271] = { name = "Rhapsody", costs = 240, model = "rhapsody", damageMultiplier = 2 },
    [-1775728740] = { name = "Granger", costs = 270, model = "granger", damageMultiplier = 3 },
    [-1894894188] = { name = "Surge", costs = 370, model = "surge", damageMultiplier = 3 },
    [-685276541] = { name = "Emperor", costs = 410, model = "emperor", damageMultiplier = 4 },
    [65402552] = { name = "Youga", costs = 140, model = "youga", damageMultiplier = 2 },
    [-1903012613] = { name = "Asterope", costs = 360, model = "asterope", damageMultiplier = 4 },
    [970598228] = { name = "Sultan", costs = 200, model = "sultan", damageMultiplier = 1 },
    [-431692672] = { name = "Panto", costs = 210, model = "panto", damageMultiplier = 2 },
    [-808831384] = { name = "Classic Baller", costs = 450, model = "baller", damageMultiplier = 4 },
    [-1297672541] = { name = "Jester", costs = 600, model = "jester", damageMultiplier = 6 },
    [1777363799] = { name = "Washington", costs = 120, model = "washington", damageMultiplier = 2 },
    [1123216662] = { name = "Super Diamond", costs = 500, model = "superd", damageMultiplier = 8 },
    [1032823388] = { name = "Obey 9F", costs = 450, model = "ninef", damageMultiplier = 7 },
    [2053223216] = { name = "Benson", costs = 360, model = "benson", damageMultiplier = 8 },
    [1162065741] = { name = "Rumpo", costs = 270, model = "rumpo", damageMultiplier = 8 },
    [-1289722222] = { name = "Ingot", costs = 180, model = "ingot", damageMultiplier = 2 },
    [1039032026] = { name = "Blista XS", costs = 360, model = "blista2", damageMultiplier = 3 },
    [1069929536] = { name = "BobcatXL", costs = 400, model = "bobcatxl", damageMultiplier = 4 },
    [1221512915] = { name = "Seminole", costs = 420, model = "seminole", damageMultiplier = 4 },
    [-227741703] = { name = "Ruiner", costs = 290, model = "ruiner", damageMultiplier = 3 },
    [1830407356] = { name = "Peyote", costs = 340, model = "peyote", damageMultiplier = 4 },
    [-310465116] = { name = "Minivan", costs = 300, model = "minivan", damageMultiplier = 3 },
    [-1543762099] = { name = "Gresley", costs = 370, model = "gresley", damageMultiplier = 4 },
    [-344943009] = { name = "Blista", costs = 390, model = "blista", damageMultiplier = 3 },
    [2016857647] = { name = "Futo", costs = 150, model = "futo", damageMultiplier = 1 },
    [1353720154] = { name = "Flatbed", costs = 380, model = "flatbed", damageMultiplier = 3 },
    [569305213] = { name = "Packer", costs = 270, model = "packer", damageMultiplier = 2 },
}

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('chopshop:chopVehicle')
AddEventHandler('chopshop:chopVehicle', function(vehicleProps, model)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll("SELECT state FROM owned_vehicles WHERE plate = @plate", { ['@plate'] = vehicleProps.plate }, function(result)
        if (result[1]) then
            TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Chop Shop", "That vehicle is too hot, get it out of here!", 'fas fa-car', "red")
        else
            local payOut = shoppingList[vehicleProps.model].costs
            if xPlayer.job.name == exports.strp_gangturfs:getTurfOwner(1) then
                payOut = math.ceil(payOut + ((payOut/100)*20))
                TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Chop Shop", "You were paid $" .. payOut .. " for chopping the vehicle, this includes a bonus for turf ownership", 'fas fa-car', "red")
            else
                TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "Chop Shop", "You were paid $" .. payOut .. " for chopping the vehicle.", 'fas fa-car', "red")
            end
            xPlayer.addAccountMoney('black_money', payOut)
        end
    end)
end)

