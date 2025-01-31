local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,["-"] = 84,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}


ESX                           = nil
local GUI      = {}
local PlayerData                = {}
local lastVehicle = nil
local lastOpen = false
GUI.Time                      = 0
local vehiclePlate = {}
local arrayWeight = Config.localWeight
local CloseToVehicle = false
local entityWorld = nil
local globalplate = nil

function getItemyWeight(item)
  local weight = 0
  local itemWeight = -1

  if item ~= nil then
	   itemWeight = Config.DefaultWeight
	   if arrayWeight[item] ~= nil then
	        itemWeight = arrayWeight[item]
	   end
	end
  return itemWeight
end


Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  	PlayerData = xPlayer
    TriggerServerEvent("esx_truck_inventory:getOwnedVehicule")
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

RegisterNetEvent('esx_truck_inventory:setOwnedVehicule')
AddEventHandler('esx_truck_inventory:setOwnedVehicule', function(vehicle)
    vehiclePlate = vehicle
end)

function VehicleInFront()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 4.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
    local a, b, c, d, result = GetRaycastResult(rayHandle)
    return result
end

function openmenuvehicle()
	local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed)
	local vehicle   =VehicleInFront()
	globalplate  = GetVehicleNumberPlateText(vehicle)
	if globalplate ~= nil or globalplate ~= "" or globalplate ~= " " then
		ESX.TriggerServerCallback('esx_truck:checkvehicle',function(valid)
			if (not valid) then
				-- CloseToVehicle = true
				-- TriggerServerEvent('esx_truck_inventory:AddVehicleList', globalplate)
				local vehFront = VehicleInFront()
				local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
				local closecar = GetClosestVehicle(x, y, z, 4.0, 0, 71)
			    
                if vehFront > 0 and closecar ~= nil and GetPedInVehicleSeat(closecar, -1) ~= GetPlayerPed(-1) then
					lastVehicle = vehFront
					local model = GetDisplayNameFromVehicleModel(GetEntityModel(closecar))
					local locked = GetVehicleDoorLockStatus(closecar)
					local class = GetVehicleClass(vehFront)
                    local vehCoords = GetWorldPositionOfEntityBone(vehFront, GetEntityBoneIndexByName(vehFront, 'boot'))
					ESX.UI.Menu.CloseAll()
					if not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'inventory') then
                        if locked == 1 then
                            SetVehicleDoorOpen(vehFront, 5, false, false)
                            ESX.UI.Menu.CloseAll()
                            if globalplate ~= nil or globalplate ~= "" or globalplate ~= " " then
                                CloseToVehicle = true
                                TriggerServerEvent('esx_truck_inventory:AddVehicleList', globalplate)
                                TriggerServerEvent("esx_truck_inventory:getInventory", GetVehicleNumberPlateText(vehFront))
                                lastOpen = true
				                GUI.Time  = GetGameTimer()
                            end
                        else
                            ESX.ShowNotification('The trunk is locked.')
                        end
					end
				else
					ESX.ShowNotification('You are not near a trunk')
				end
			else
				TriggerEvent('esx:showNotification', "Someone else is using the trunk.")
			end
		end, globalplate)
	end
end

local count = 0
-- Key controls
Citizen.CreateThread(function()
    while true do
        Wait(0)
        if lastOpen and IsControlPressed(0, Keys["-"]) and (GetGameTimer() - GUI.Time) > 150 then
            ESX.UI.Menu.CloseAll()
            CloseToVehicle = false
            lastOpen = false
            if lastVehicle > 0 then
                SetVehicleDoorShut(lastVehicle, 5, false)
                local lastvehicleplatetext = GetVehicleNumberPlateText(lastVehicle)
                TriggerServerEvent('esx_truck_inventory:RemoveVehicleList', lastvehicleplatetext)
                lastVehicle = 0
            end
            GUI.Time  = GetGameTimer()
        elseif IsControlPressed(0, Keys["-"]) and (GetGameTimer() - GUI.Time) > 500 then
            if count == 0 then
                openmenuvehicle()
                count = count +1
            else
                Wait(150)
                count = 0
            end
        end
    end
end)

-- CloseToVehicle
Citizen.CreateThread(function()
    while true do

    Wait(0)
	local pos = GetEntityCoords(GetPlayerPed(-1))
	if CloseToVehicle then
		local vehicle = GetClosestVehicle(pos['x'], pos['y'], pos['z'], 4.0, 0, 71)
		if DoesEntityExist(vehicle) then
			CloseToVehicle = true
		else
			TriggerServerEvent('esx_truck_inventory:RemoveVehicleList', globalplate)
			CloseToVehicle = false
			lastOpen = false
			ESX.UI.Menu.CloseAll()
			SetVehicleDoorShut(lastVehicle, 5, false)
		end
	end
  end
end)

RegisterNetEvent('esx_truck_inventory:getInventoryLoaded')
AddEventHandler('esx_truck_inventory:getInventoryLoaded', function(inventory,weight)
	local elements = {}
	local vehFrontBack = VehicleInFront()
    TriggerServerEvent("esx_truck_inventory:getOwnedVehicule")

	table.insert(elements, {
        label     = 'Deposit',
        count     = 0,
        value     = 'deposit',
    })

	if inventory ~= nil and #inventory > 0 then
		for i=1, #inventory, 1 do
            if inventory[i].type == 'item_standard' then
                table.insert(elements, {
                    label     = inventory[i].label .. ' x' .. inventory[i].count,
                    count     = inventory[i].count,
                    value     = inventory[i].name,
                    type	  = inventory[i].type
                })
            elseif inventory[i].type == 'item_weapon' then
                table.insert(elements, {
                    label     = inventory[i].label .. ' | munitions: ' .. inventory[i].count,
                    count     = inventory[i].count,
                    value     = inventory[i].name,
                    type	  = inventory[i].type
                })
            elseif inventory[i].type == 'item_account' then
                table.insert(elements, {
                    label     = inventory[i].label .. ' [ $' .. inventory[i].count..' ]',
                    count     = inventory[i].count,
                    value     = inventory[i].name,
                    type	  = inventory[i].type
                })
			end
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'inventory_deposit',
	{
        title    = 'Trunk Inventory (' .. weight .. '/' .. tonumber(Config.VehicleLimit[GetEntityModel(vehFrontBack)].trunksize) .. ')',
        align    = 'bottom-right',
        elements = elements,
	}, function(data, menu)
	  	if data.current.value == 'deposit' then
	  		local elem = {}
			-- xPlayer.getAccount('black_money').money
			-- table.insert(elements, {label = 'Argent sale: ' .. inventory.blackMoney, type = 'item_account', value = 'black_money'})

	  		PlayerData = ESX.GetPlayerData()
			for i=1, #PlayerData.accounts, 1 do
				if PlayerData.accounts[i].name == 'black_money' then
				  -- if PlayerData.accounts[i].money > 0 then
				    table.insert(elem, {
                        label     = PlayerData.accounts[i].label .. ' [ $'.. math.floor(PlayerData.accounts[i].money+0.5) ..' ]',
                        count     = PlayerData.accounts[i].money,
                        value     = PlayerData.accounts[i].name,
                        name      = PlayerData.accounts[i].label,
                        limit     = PlayerData.accounts[i].limit,
                        type		= 'item_account',
				    })
				  -- end
				end
			end

			for i=1, #PlayerData.inventory, 1 do
				if PlayerData.inventory[i].count > 0 then
				    table.insert(elem, {
                        label     = PlayerData.inventory[i].label .. ' x' .. PlayerData.inventory[i].count,
                        count     = PlayerData.inventory[i].count,
                        value     = PlayerData.inventory[i].name,
                        name      = PlayerData.inventory[i].label,
                        limit     = PlayerData.inventory[i].limit,
                        type		= 'item_standard',
				    })
				end
			end

            local playerPed  = GetPlayerPed(-1)
            local weaponList = ESX.GetWeaponList()

            for i=1, #weaponList, 1 do
                local weaponHash = GetHashKey(weaponList[i].name)

                if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
                    local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
                    table.insert(elem, {label = weaponList[i].label .. ' [' .. ammo .. ']',name = weaponList[i].label, type = 'item_weapon', value = weaponList[i].name, count = ammo})
                end
            end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'inventory_player',
			{
			    title    = 'Inventory Contents',
			    align    = 'bottom-right',
			    elements = elem,
			}, function(data3, menu3)
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'inventory_item_count_give', { title = 'quantity' },
			function(data4, menu4)
                local quantity = tonumber(data4.value)
                local Itemweight =tonumber(getItemyWeight(data3.current.value)) * quantity
                local totalweight = tonumber(weight) + Itemweight
                vehFront = VehicleInFront()
                local typeVeh = GetEntityModel(vehFront)

                if totalweight > Config.VehicleLimit[typeVeh].trunksize then
                    max = true
                else
                    max = false
                end

                ownedV = 0
                while vehiclePlate == '' do
                    Wait(1000)
                end
                for i=1, #vehiclePlate do
                    if vehiclePlate[i].plate == GetVehicleNumberPlateText(vehFront) then
                        ownedV = 1
                        break
                    else
                        ownedV = 0
                    end
                end

                --fin test

                if quantity > 0 and quantity <= tonumber(data3.current.count) and vehFront > 0  then
                    local MaxVh =(tonumber(Config.VehicleLimit[typeVeh].trunksize))
                    local Kgweight =  totalweight
                    if not max then
                        local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
                        local closecar = GetClosestVehicle(x, y, z, 4.0, 0, 71)

                        TriggerServerEvent('esx_truck_inventory:addInventoryItem', GetVehicleClass(closecar), GetDisplayNameFromVehicleModel(GetEntityModel(closecar)), GetVehicleNumberPlateText(vehFront), data3.current.value, quantity, data3.current.name, data3.current.type, ownedV)
                        ESX.ShowNotification('Trunk Inventory Weight: '.. Kgweight .. ' / '..MaxVh)
                        Citizen.Wait(500)
                        TriggerServerEvent("esx_truck_inventory:getInventory", GetVehicleNumberPlateText(vehFront))
                    else
                        ESX.ShowNotification('You have reached the limit of '..MaxVh..'')
                    end
                else
                    ESX.ShowNotification('Invalid Quantity')
                end

                ESX.UI.Menu.CloseAll()

                end, function(data4, menu4)
                    SetVehicleDoorShut(vehFrontBack, 5, false)
                    ESX.UI.Menu.CloseAll()
                    local lastvehicleplatetext = GetVehicleNumberPlateText(vehFrontBack)
                    TriggerServerEvent('esx_truck_inventory:RemoveVehicleList', lastvehicleplatetext)
                end)
            end, function(data, menu)
                menu.close()
            end)
		elseif data.current.type == 'cancel' then
			menu.close()
	  	else
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'inventory_item_count_give', { title = 'quantity' },
			function(data2, menu2)
			    local quantity = tonumber(data2.value)
				PlayerData = ESX.GetPlayerData()
			    vehFront = VehicleInFront()

                --test
                local Itemweight =tonumber(getItemyWeight(data.current.value)) * quantity
                local poid = weight - Itemweight

                local invWeight = 0
                for i=1, #PlayerData.inventory, 1 do
                    invWeight = invWeight + PlayerData.inventory[i].count
                end

                if (invWeight ~= -1 and (invWeight + quantity) <= 20) or data.current.value == "black_money" then
                    max = false
                else
                    max = true
                end
                --fin test

                if quantity > 0 and quantity <= tonumber(data.current.count) and vehFront > 0 then
                    if not max then
                        TriggerServerEvent('esx_truck_inventory:removeInventoryItem', GetVehicleNumberPlateText(vehFront), data.current.value, data.current.type, quantity)
                        local typeVeh = GetEntityModel(vehFront)
                        local MaxVh =(tonumber(Config.VehicleLimit[typeVeh].trunksize))
                        local Itemweight =tonumber(getItemyWeight(data.current.value)) * quantity
                        local totalweight = tonumber(weight) - Itemweight
                        local Kgweight =  totalweight
                        ESX.ShowNotification('Trunk Inventory Weight: '.. Kgweight .. ' / '..MaxVh)
                    else
                        ESX.ShowNotification('You are carrying too much.')
                    end
                else
                    ESX.ShowNotification('Invalid Quantity.')
                end

			    ESX.UI.Menu.CloseAll()

	        	local vehFront = VehicleInFront()
	          	if vehFront > 0 then
	          		ESX.SetTimeout(1500, function()
	              		TriggerServerEvent("esx_truck_inventory:getInventory", GetVehicleNumberPlateText(vehFront))
	          		end)
	            else
	                SetVehicleDoorShut(vehFrontBack, 5, false)
	            end
            end, function(data2, menu2)
                --SetVehicleDoorShut(vehFrontBack, 5, false)
                ESX.UI.Menu.CloseAll()
                local lastvehicleplatetext = GetVehicleNumberPlateText(vehFrontBack)
                TriggerServerEvent('esx_truck_inventory:RemoveVehicleList', lastvehicleplatetext)
            end)
        end
    end, function(data, menu)
        menu.close()
    end)
end)


function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. '['..k..'] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end
