ESX = nil
local shopItems = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()

	MySQL.Async.fetchAll('SELECT * FROM weashops', {}, function(result)
		for i=1, #result, 1 do
			if shopItems[result[i].zone] == nil then
				shopItems[result[i].zone] = {}
			end

			table.insert(shopItems[result[i].zone], {
				item  = result[i].item,
				price = result[i].price,
				label = ESX.GetWeaponLabel(result[i].item)
			})
		end

		TriggerClientEvent('esx_weaponshop:sendShop', -1, shopItems)
	end)

end)

ESX.RegisterServerCallback('esx_weaponshop:getShop', function(source, cb)
	cb(shopItems)
end)

ESX.RegisterServerCallback('esx_weaponshop:buyLicense', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= Config.LicensePrice then
		xPlayer.removeMoney(Config.LicensePrice)

		TriggerEvent('esx_license:addLicense', source, 'weapon', function()
			cb(true)
		end)
	else
		TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "AmmuNation", _U('not_enough'), 'fas fa-exclamation-triangle', "red")
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_weaponshop:buyWeapon', function(source, cb, weaponName, zone)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = GetPrice(weaponName, zone)
    local ammopurchase = false

	if price == 0 then
		print(('esx_weaponshop: %s attempted to buy a unknown weapon!'):format(xPlayer.identifier))
		cb(false, false)
	end

	if xPlayer.hasWeapon(weaponName) then
        price = math.ceil(price / 2)
        ammopurchase = true
		-- TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "AmmuNation", _U('already_owned'), 'fas fa-exclamation-triangle', "red")
		-- cb(false)
	end
    
    if zone == 'BlackWeashop' then
        if xPlayer.job.name == exports.strp_gangturfs:getTurfOwner(3) then
            price = math.ceil(price - ((price/100)*20))
        end

        if xPlayer.getAccount('black_money').money >= price then
            xPlayer.removeAccountMoney('black_money', price)
            xPlayer.addWeapon(weaponName, 42)

            cb(true, ammopurchase)
        else
            TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "AmmuNation", _U('not_enough_black'), 'fas fa-exclamation-triangle', "red")
            cb(false, false)
        end
    else
        if xPlayer.getMoney() >= price then
            xPlayer.removeMoney(price)
            xPlayer.addWeapon(weaponName, 42)
            cb(true, ammopurchase)
        else
            TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "AmmuNation", _U('not_enough'), 'fas fa-exclamation-triangle', "red")
            cb(false, false)
        end
    end
end)

function GetPrice(weaponName, zone)
	local price = MySQL.Sync.fetchScalar('SELECT price FROM weashops WHERE zone = @zone AND item = @item', {
		['@zone'] = zone,
		['@item'] = weaponName
	})

	if price then
		return price
	else
		return 0
	end
end
