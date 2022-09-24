local QBCore = exports['qb-core']:GetCoreObject()
local selFine = nil

QBCore.Commands.Add('bill','Bill A Player {Police/EMS}',{},false,function(source)
    local biller = QBCore.Functions.GetPlayer(source)
    if biller.PlayerData.job.name == 'police' then
        TriggerClientEvent('ktrp-billing:client:Menu',source,"police")
    end
    if biller.PlayerData.job.name == "ambulance" then
        TriggerClientEvent('ktrp-billing:client:Menu',source,"ambulance")
    end
end)

RegisterNetEvent('ktrp-billing:server:billPlayer',function(billName,billAmount,billedPlayerID,jobReq)
	selAmount = billAmount
    local biller = QBCore.Functions.GetPlayer(source)
    local billed = QBCore.Functions.GetPlayer(billedPlayerID)
    local amount = tonumber(selAmount)
    if jobReq == "police" then 
    	if billed.PlayerData.job.name ~= 'police' then
    		if billed ~= nil then
        		if biller.PlayerData.citizenid ~= billed.PlayerData.citizenid then
            		if amount and amount > 0 then
                    	billed.Functions.RemoveMoney('bank', amount, "paid-fine")
                    	TriggerClientEvent('QBCore:Notify', source, billName.." Fine has been issued to "..billed.PlayerData.charinfo.firstname.." "..billed.PlayerData.charinfo.lastname.." successfully", 'success')
                    	TriggerClientEvent('QBCore:Notify', billed.PlayerData.source,'You Have Been Fined  '..selAmount.."$ for "..billName)
                    	exports["qb-management"]:AddMoney('police', amount)
                        local message = "**"..biller.PlayerData.charinfo.firstname.." "..biller.PlayerData.charinfo.lastname.."("..biller.PlayerData.citizenid..")** Fined an Amount of **"..selAmount.."$** for **"..billName.. "** to **"..billed.PlayerData.charinfo.firstname.." "..billed.PlayerData.charinfo.lastname.."("..billed.PlayerData.citizenid..")**"
                        TriggerEvent('qb-log:server:CreateLog',"policeFineLog","Police Fine","blue",message)
                	else
                    	TriggerClientEvent('QBCore:Notify', source, 'Must Be A Valid Amount Above 0', 'error')
                	end
            	else
            		TriggerClientEvent('QBCore:Notify', source, 'You Cannot Fine Yourself', 'error')
            	end
        	else
        		TriggerClientEvent('QBCore:Notify', source,' No One Found Nearby', 'error')
        	end
    	else
        	TriggerClientEvent('QBCore:Notify', source, "Police can't be Fined", 'error')
    	end
    end
    if jobReq == "ambulance" then 
       	if billed.PlayerData.job.name ~= 'ambulance' then
    		if billed ~= nil then
        		if biller.PlayerData.citizenid ~= billed.PlayerData.citizenid then
            		if amount and amount > 0 then
                    	billed.Functions.RemoveMoney('bank', amount, "paid-bill")
                    	TriggerClientEvent('QBCore:Notify', source, billName.." bill has been issued to "..billed.PlayerData.charinfo.firstname.." "..billed.PlayerData.charinfo.lastname.." successfully", 'success')
                    	TriggerClientEvent('QBCore:Notify', billed.PlayerData.source,'You Have Been Billed  '..billAmount.."$ for "..billName)
                    	exports["qb-management"]:AddMoney('ambulance', amount)
                        local message = biller.PlayerData.charinfo.firstname.." "..biller.PlayerData.charinfo.lastname.."("..biller.PlayerData.citizeid..") Billed an Amount of "..selAmount.."$ for "..billName.. " to "..billed.PlayerData.charinfo.firstname.." "..billed.PlayerData.charinfo.lastname.."("..billed.PlayerData.citizeid..")"
                        TriggerEvent('qb-log:server:CreateLog',"emsBillLog","EMS Bill","blue",message)    
                	else
                    	TriggerClientEvent('QBCore:Notify', source, 'Must Be A Valid Amount Above 0', 'error')
                	end
            	else
            		TriggerClientEvent('QBCore:Notify', source, 'You Cannot Bill Yourself', 'error')
            	end
        	else
        		TriggerClientEvent('QBCore:Notify', source,' No One Found Nearby', 'error')
        	end
    	else
        	TriggerClientEvent('QBCore:Notify', source, "EMS can't be Billed", 'error')
    	end     
    end        
end)
