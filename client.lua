--------------------------------
------- Created by Angus -------
-------------------------------- 

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

local NuBezig   = false
local goodnight = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        goodnight = true
        local pos = GetEntityCoords(GetPlayerPed(-1), true)
        if IsPedSittingInAnyVehicle(PlayerPedId()) then
            for i = 1, #Rocket.Carwashloc do
                if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Rocket.Carwashloc[i].x, Rocket.Carwashloc[i].y, Rocket.Carwashloc[i].z, true) < 5 then
                    goodnight = false
                    DrawMarker(20, vector3(Rocket.Carwashloc[i].x, Rocket.Carwashloc[i].y, Rocket.Carwashloc[i].z), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.2, 147, 112, 219, 100, false, true, 2, true, false, false, false)
                    if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Rocket.Carwashloc[i].x, Rocket.Carwashloc[i].y, Rocket.Carwashloc[i].z, true) < 2.5 then
                        DrawScriptText(vector3(Rocket.Carwashloc[i].x, Rocket.Carwashloc[i].y, Rocket.Carwashloc[i].z), '~p~E~w~ · Voertuig Wassen')
                        if IsControlJustReleased(0, Keys["E"]) then
                            if not NuBezig then
                                NuBezig = true
                                voertuigwassenjonge()
                            else
                                exports['mythic_notify']:DoHudText('error', 'Je bent al bezig met je voertuig te wassen')
                            end
                        end
                    end
                end
            end
        end
        if goodnight then
            Wait(1000)
        end
    end
end)

function voertuigwassenjonge()
    local car = GetVehiclePedIsUsing(PlayerPedId())
	local ped = GetEntityCoords(PlayerPedId())
    ESX.TriggerServerCallback('rocket-carwash:heeftgeld', function(heeftgeld)
        if heeftgeld then
        TriggerServerEvent('rocket-carwash:verwijdergeld')
        if not HasNamedPtfxAssetLoaded("core") then
            RequestNamedPtfxAsset("core")
            while not HasNamedPtfxAssetLoaded("core") do
                Citizen.Wait(1)
            end
        end
        UseParticleFxAssetNextCall("core")
        particles  = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p", ped.x, ped.y, ped.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
        UseParticleFxAssetNextCall("core")
        particles2  = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p", ped.x + 2, ped.y, ped.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)

            Progressbar("voertuig_wassen", "Voertuig Wassen..", 8000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
                }, {
                flags = 16,
                }, {}, {}, function()
                    WashDecalsFromVehicle(car, 1.0)
                    SetVehicleDirtLevel(car)
                    StopParticleFxLooped(particles, 0)
                    StopParticleFxLooped(particles2, 0)
                    NuBezig = false
                    exports['mythic_notify']:DoHudText('success', 'Je voertuig is schoongemaakt!')
                end, function()
            end)
        end
    end)
end

Citizen.CreateThread(function()
    for i = 1, #Rocket.Carwashloc do
        blipwash = AddBlipForCoord(Rocket.Carwashloc[i].x, Rocket.Carwashloc[i].y, Rocket.Carwashloc[i].z)
        SetBlipSprite (blipwash, 100)
        SetBlipDisplay(blipwash, 4)
        SetBlipScale  (blipwash, 1.0)
        SetBlipColour (blipwash, 18)
        SetBlipAsShortRange(blipwash, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Car Wash')
        EndTextCommandSetBlipName(blipwash)
    end
end)

Progressbar = function(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
    exports['progressbar']:Progress({
        name = name:lower(),
        duration = duration,
        label = label,
        useWhileDead = useWhileDead,
        canCancel = canCancel,
        controlDisables = disableControls,
        animation = animation,
        prop = prop,
        propTwo = propTwo,
    }, function(cancelled)
        if not cancelled then
            if onFinish ~= nil then
                onFinish()
            end
        else
            if onCancel ~= nil then
                onCancel()
            end
        end
    end)
end

function DrawScriptText(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords["x"], coords["y"], coords["z"])

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)

    local factor = string.len(text) / 370

    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 65)
end