--------------------------------
------- Created by Angus -------
-------------------------------- 

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj 
end)

ESX.RegisterServerCallback('rocket-carwash:heeftgeld', function(source, cb, heeftmoney)
	local xPlayer = ESX.GetPlayerFromId(source)
		local heeftmoney = xPlayer.getMoney()
		if heeftmoney >= Rocket.Washmoney then
			cb(0)
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Heeft niet genoeg geld bij zich nodig: '..Rocket.Washmoney..' euro'})
	end
end)

RegisterServerEvent('rocket-carwash:verwijdergeld')
AddEventHandler('rocket-carwash:verwijdergeld', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local heeftmoney = xPlayer.getMoney()
	if heeftmoney >= Rocket.Washmoney then
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Je hebt '..Rocket.Washmoney..' euro betaalt om je voertuig te wassen'})
		xPlayer.removeMoney(Rocket.Washmoney)
	end
end)