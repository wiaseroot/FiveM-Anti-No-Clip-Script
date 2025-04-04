local BanEvent = "noclipBan"
local checkInterval = 2000 -- check 
local maxDistanceFromGround = 3.0 -- maximum distance 
local warningLimit = 3 -- warning 

local playerWarnings = {}
local webhookURL = "BURAYA_WEBHOOK_URL_GIRIN" -- discord webhook url

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(checkInterval)
        local players = GetPlayers()
        for _, playerId in ipairs(players) do
            local ped = GetPlayerPed(playerId)

            if DoesEntityExist(ped) and not IsPedInAnyVehicle(ped, false) then
                local pedPos = GetEntityCoords(ped, true)
                local groundZ, found = GetGroundZFor_3dCoord(pedPos.x, pedPos.y, pedPos.z, false)
                local distance = pedPos.z - groundZ

                if found and distance > maxDistanceFromGround and not IsPedFalling(ped) and not IsPedInParachuteFreeFall(ped) and not IsPedJumping(ped) then
                    if playerWarnings[playerId] == nil then
                        playerWarnings[playerId] = 1
                    else
                        playerWarnings[playerId] = playerWarnings[playerId] + 1
                    end

                    print("Oyuncu uyarıldı: " .. GetPlayerName(playerId) .. " (" .. playerWarnings[playerId] .. "/" .. warningLimit .. ")")

                    if playerWarnings[playerId] >= warningLimit then
                        TriggerEvent(BanEvent, playerId, "Noclip tespit edildi.")
                        playerWarnings[playerId] = nil
                    end
                else
                    if playerWarnings[playerId] then
                        playerWarnings[playerId] = nil
                    end
                end
            end
        end
    end
end)

AddEventHandler(BanEvent, function(playerId, reason)
    local identifiers = GetPlayerIdentifiers(playerId)
    local identifierString = table.concat(identifiers, ", ")
    DropPlayer(playerId, "Sunucudan uzaklaştırıldın. Sebep: " .. reason)
    LogBan(playerId, reason, identifierString)
end)

function LogBan(playerId, reason, identifier)
    local logMessage = "Oyuncu banlandı: " .. GetPlayerName(playerId) .. " Sebep: " .. reason .. " Identifierlar: " .. identifier
    print(logMessage)
    SendDiscordWebhook(logMessage)
end

function SendDiscordWebhook(message)
    if webhookURL ~= "" then
        PerformHttpRequest(webhookURL, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
    end
end

function GetPlayers()
    local players = {}
    for _, playerId in ipairs(GetActivePlayers()) do
        table.insert(players, playerId)
    end
    return players
end

-- Oyuncu oyuna katıldığında sıfırlama
AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    local source = source
    playerWarnings[source] = nil
end)

-- Oyuncu ayrıldığında sıfırlama
AddEventHandler('playerDropped', function(reason)
    local source = source
    playerWarnings[source] = nil
end)

-- Performans optimizasyonları
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000) -- Her dakika bellek optimizasyonu
        collectgarbage("collect")
    end
end)
