local QBCore = exports['qb-core']:GetCoreObject()
local nearPlayer = nil

--PD System
RegisterNetEvent('ktrp-billing:client:Menu', function(jobName)
        if jobName == "police" then
        	local fineList = {}
    		fineList[#fineList + 1] = { -- create non-clickable header button
        		isMenuHeader = true,
        		header = tostring(Config.Title),
        		icon = 'fa-regular fa-building'
    		}
    		for k,v in pairs(Config.Fines) do -- loop through our table
        		fineList[#fineList + 1] = { -- insert data from our loop into the menu
            		header = k,
            		txt = v.name,
            		icon = 'fa-solid fa-sack-dollar',
           	 		params = {
                		event = 'ktrp-billing:client:SubMenu', -- event name
                		args = {
                            job = "police",
                    		name = k, -- value we want to pass
                    		label = v.name,
                    		number = 1
                		}	
            		}
        		}
    		end
    		exports['qb-menu']:openMenu(fineList) -- open our menu
        end
       if jobName == "ambulance" then
            local billList = {}
    		billList[#billList + 1] = { -- create non-clickable header button
        		isMenuHeader = true,
        		header = tostring(Config.Title),
        		icon = 'fa-regular fa-building'
    		}
    		for k,v in pairs(Config.EMSBills) do -- loop through our table
        		billList[#billList + 1] = { -- insert data from our loop into the menu
            		header = k,
            		txt = v.name,
            		icon = 'fa-solid fa-sack-dollar',
           	 		params = {
                		event = 'ktrp-billing:client:SubMenu', -- event name
                		args = {
                            job = "ambulance",                            
                    		name = k, -- value we want to pass
                    		label = v.name,
                    		number = 1
                		}	
            		}
        		}
    		end
    		exports['qb-menu']:openMenu(billList) -- open our menu
       	end
end)

RegisterNetEvent('ktrp-billing:client:SubMenu', function(data)
        if data.job == "police" then
    		local number = data.number
    		local submenuList = {}
    		submenuList[#submenuList + 1] = {
       			header = 'Return to main menu',
        		icon = 'fa-solid fa-angles-left',
        		params = {
            		event = 'ktrp-billing:client:mainMenu',
            		args = {
						name = "police",
           			}
        		}
    		}
    		for l,u in pairs(Config.Fines[data.name]) do
        		submenuList[#submenuList + 1] = {
            		header = l,
            		txt = tostring(u.fine),
            		icon = 'fa-regular fa-money-bill-1',
            		params = {
                		event = 'ktrp-billing:client:Update', -- event name
                		args = {
                            job = "police",
                    		name = l, -- value we want to pass
                    		label = u.name,
                    		amount = u.fine
                		}
    				} 
       			}
            
    		end
    		exports['qb-menu']:openMenu(submenuList)
        end
        if data.job == "ambulance" then
        	local number = data.number
    		local submenuList = {}
    		submenuList[#submenuList + 1] = {
        		header = 'Return to main menu',
        		icon = 'fa-solid fa-angles-left',
        		params = {
            		event = 'ktrp-billing:client:mainMenu',
            		args = {
                    		name = "ambulance"
                	}
        		}
    		}
    		for l,u in pairs(Config.EMSBills[data.name]) do
        		submenuList[#submenuList + 1] = {
            		header = l,
            		txt = tostring(u.bill),
            		icon = 'fa-regular fa-money-bill-1',
            		params = {
                		event = 'ktrp-billing:client:Update', -- event name
                		args = {
                            job = "ambulance",
                    		name = l, -- value we want to pass
                    		label = u.name,
                    		amount = u.bill
                		}
    				} 
       		}
    		end
    		exports['qb-menu']:openMenu(submenuList)
         end
end)



RegisterNetEvent('ktrp-billing:client:mainMenu', function(jobName)
	ExecuteCommand("bill")  	
end)

function getNearPlayer()
	local player, distance = QBCore.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 1.5 then 
    	nearPlayer = GetPlayerServerId(player)
    else
    	TriggerEvent('QBCore:Notify',"No one nearby","success")
    end
end

RegisterNetEvent('ktrp-billing:client:Update', function(data)
	nearPlayer = 0
    getNearPlayer()
    if nearPlayer ~= nil and nearPlayer ~= 0 then
    	TriggerServerEvent('ktrp-billing:server:billPlayer',data.name,data.amount,nearPlayer,data.job)
        ExecuteCommand("bill")    
    end
        

end)