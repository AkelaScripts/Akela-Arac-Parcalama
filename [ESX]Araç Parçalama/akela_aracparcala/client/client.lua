local Keys = {
 ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
 ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
 ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
 ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
 ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
 ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
 ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
 ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
 ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
   
ESX = nil
local PlayerData              = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
		PlayerData = ESX.GetPlayerData()
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
function ShowNotification( text )
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    DrawNotification(false, false)
end

local loc = Config.Locations
local alreadyProcess = false
local carr = {}
Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)
		local pos = GetEntityCoords(ped,0)
		local car = GetVehiclePedIsIn(ped,true)
		carr = car
		local distance = Vdist2(pos.x, pos.y, pos.z, loc.x, loc.y, loc.z)
		local inside = IsPedInVehicle(ped, car, true)
		if distance <= 12 and inside then
			if alreadyProcess == false then
				DrawMarker(2, loc.x, loc.y, loc.z, 0, 0, 0, 0, 0, 0, 0.4, 0.4, 0.4, 190, 15, 20, 155, false, false, 2, true, nil, nil, false)
				if distance <= 1 then 
					hintToDisplay('Aracı parçalamak için ~INPUT_CONTEXT~ bas')
					
					if IsControlJustPressed(0, Keys['E']) then
							TriggerServerEvent('akela_aracparcala:basla')
							SetVehicleEngineHealth(car, -999)
							alreadyProcess = true
							SetVehicleDoorsLockedForAllPlayers(car, true)
							for i = 0, 7 do
							  SetVehicleDoorOpen(car, i, false, true)
							end
							exports['mythic_notify']:SendAlert('inform', 'Parçalama işlemi başladı!')
							parcala()
							
					end	
				end	
			end	
		end 
		if distance >= 3 then
			if alreadyProcess == true then 
				alreadyProcess = false
				exports['mythic_notify']:SendAlert('error', 'Parçalama işlemi iptal edildi!')
				iptal()
			end
		end
	end	
end)
function parcala()
	exports['mythic_progbar']:Progress({
        name = "parcala",
        duration = 65500,
        label = 'Parçalar sökülüyor...',
        useWhileDead = false,
        canCancel = false,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
    }, function(cancelled)
        if not cancelled then
			TriggerServerEvent('akela_aracparcala:parcala')
			alreadyProcess = false
			DeleteEntity(carr)
        end
    end)
end

function DrawText3D(x, y, z, scale, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	if onScreen then
		SetTextScale(scale, scale)
		SetTextFont(0)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextDropshadow(0)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 380
        DrawRect(_x, _y + 0.0125, 0.06 + factor, 0.030, 0, 0, 0, 75)
	end
end


RegisterNetEvent('akela_aracparcala:pdbildir')
AddEventHandler('akela_aracparcala:pdbildir', function()
		local ped = GetPlayerPed(-1)
		local pos = GetEntityCoords(ped,0)
		local code = math.random(100, 999)
		local sex = IsPedModel(ped, 'mp_m_freemode_01')
		local sex2 = IsPedModel(ped, 'mp_f_freemode_01')
		local psex = {}
		if sex then 
			psex = 'Erkek'
		elseif sex2 then 
			psex = 'Kadın'
		else 
			psex = 'Cinsiyeti Yok'
		end	
		local data = {displayCode = code, description = 'Araç Parçalanıyor', isImportant = 0, recipientList = {'police'}, length = '10000', infoM = 'fa-info-circle', info = psex..' - Süre 65 saniye'}
		local dispatchData = {dispatchData = data, caller = 'Alarm', coords = vector3(pos.x, pos.y, pos.z)}
		TriggerServerEvent('wf-alerts:svNotify', dispatchData)
end)

Citizen.CreateThread(function()
    while ESX == nil or ESX.PlayerData == nil do
		Citizen.Wait(0)
	end
    while true do
        local sleepThread = 1000
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
                local distance = GetDistanceBetweenCoords(pedCoords, Config.SellLocation, true)
                if distance < 3.0 then
                    sleepThread = 5
                    DrawText3D(Config.SellLocation.x, Config.SellLocation.y, Config.SellLocation.z + 1.7, 0.35, '~g~E~w~ - Araç Parçalarını Sat')
                    if IsControlJustReleased(1, 38) then
                        sellWine(0)
                    end
                else
                    sleepThread = 1000
                end
        Citizen.Wait(sleepThread)
    end
end)

function sellWine(amount)
	TriggerServerEvent("akela_aracparcala:sat")    
end

-- SATIŞ NPC
Citizen.CreateThread(function()

	
    local ped_hash2 = 'a_m_m_hillbilly_01'
    local ped_coords2 = { x = 244.68, y = 374.55, z = 104.74, h = 156.39} -- Kordinat Giriniz
    
    RequestModel(ped_hash2)
    while not HasModelLoaded(ped_hash2) do
        Wait(1)
    end
    
    ped_info2 = CreatePed(1, ped_hash2, ped_coords2.x, ped_coords2.y, ped_coords2.z, ped_coords2.h, false, true)
    SetBlockingOfNonTemporaryEvents(ped_info2, true) 
    SetPedDiesWhenInjured(ped_info2, false) 
    SetPedCanPlayAmbientAnims(ped_info2, true) 
    SetPedCanRagdollFromPlayerImpact(ped_info2, false) 
    SetEntityInvincible(ped_info2, true)    
    FreezeEntityPosition(ped_info2, true) 
    TaskStartScenarioInPlace(ped_info2, "WORLD_HUMAN_GUARD_STAND", 0, true); 
end)