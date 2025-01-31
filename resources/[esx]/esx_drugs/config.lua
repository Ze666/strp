Config = {}

Config.Locale = 'en'
Config.Delays = {
	WeedProcessing = 1000 * 10,
	WineProcessing = 1000 * 10,
	CokeProcessing = 1000 * 10
}

Config.DrugDealerItems = {
    GiveBlack = true, -- give black money? if disabled it'll give regular cash.
	marijuana = 155
	-- cocaine = 91
}
Config.WineDealerItems = {
    GiveBlack = false, -- give black money? if disabled it'll give regular cash.
	wine = 110
}

Config.LicenseEnable = false -- enable processing licenses? The player will be required to buy a license in order to process drugs. Requires esx_license
Config.LicensePrices = {
	weed_processing = {label = _U('license_weed'), price = 15000},
	Wine_processing = {label = _U('license_weed'), price = 15000},
	Coke_processing = {label = _U('license_cocaine'), price = 15000}
	

}

Config.CircleZones = {
	WeedField = {coords = vector3(310.91, 4290.87, 45.15), name = _U('blip_weedfield'), color = 25, sprite = 496, radius = 0.0},
	WeedProcessing = {coords = vector3(2329.02, 2571.29, 46.68), name = _U('blip_weedprocessing'), color = 25, sprite = 496, radius = 0.0},
	DrugDealer = {coords = vector3(-1172.02, -1571.98, 4.66), name = _U('blip_drugdealer'), color = 6, sprite = 500, radius = 0.0},

	CokeField = {coords = vector3(3342.58, 5486.33, 20.13), name = "Coca Field", color = 24, sprite = 496, radius = 0.0},

	WineField = {coords = vector3(-1875.65, 2136.15, 126.71), name = "Marlowe Wine Fields", color = 27, sprite = 496, radius = 0.0},
	WineProcessing = {coords = vector3(-1956.22, 1776.29, 183.06), name = "Wine Processing", color = 27, sprite = 496, radius = 0.0},
	WineDealer = {coords = vector3(1719.40, 4759.40, 42.04), name = "Wine Distributor", color = 27, sprite = 500, radius = 0.0},
}

Config.CokeProcess = {
	CokeProcessing = {coords = vector3(1090.27, -3194.82, -38.99), name = "Coke Processing", color = 24, sprite = 496, radius = 0.0},

}