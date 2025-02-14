local QBCore = exports['qb-core']:GetCoreObject()
local Config = Config or {}

-- Coordenadas da arena de PVP
local pvpCoords = Config.PVPCoords

-- Tabela para armazenar os jogadores no PvP e a fila
local playersInPVP = {}
local pvpQueue = {}

-- Tabela para armazenar inventários dos jogadores
local playerInventories = {}

-- Contador de rodadas
local currentRound = 0

-- Dimensão separada para PvP
local pvpDimension = 1000

-- Evento para adicionar jogador à fila de PvP
RegisterNetEvent('pvp:addToQueue')
AddEventHandler('pvp:addToQueue', function()
    local playerId = source
    if not IsPlayerInQueue(playerId) then
        print("Jogador " .. playerId .. " adicionado à fila de PvP") -- Debug
        table.insert(pvpQueue, playerId)

        if #pvpQueue >= 2 then
            -- Iniciar PvP com os dois primeiros jogadores na fila
            StartPVP(pvpQueue[1], pvpQueue[2])
            -- Remover jogadores da fila
            table.remove(pvpQueue, 1)
            table.remove(pvpQueue, 1)
        else
            -- Notificar jogador que está na fila
            TriggerClientEvent('QBCore:Notify', playerId, "Aguardando outro jogador para iniciar o PvP...", "info")
        end
    else
        TriggerClientEvent('QBCore:Notify', playerId, "Você já está na fila de PvP.", "error")
    end
end)

-- Evento para iniciar o PvP diretamente
RegisterNetEvent('pvp:startDirect')
AddEventHandler('pvp:startDirect', function()
    local playerId = source
    if playersInPVP[playerId] then
        TriggerClientEvent('QBCore:Notify', playerId, "Você já está no PvP.", "error")
    else
        table.insert(playersInPVP, playerId)
        if #playersInPVP >= 2 then
            StartPVP(playersInPVP[1], playersInPVP[2])
        end
    end
end)

-- Função para verificar se o jogador já está na fila
function IsPlayerInQueue(playerId)
    for _, id in ipairs(pvpQueue) do
        if id == playerId then
            return true
        end
    end
    return false
end

-- Função para iniciar o PvP
function StartPVP(player1, player2)
    playersInPVP[player1] = true
    playersInPVP[player2] = true
    currentRound = 1

    -- Salvar inventário dos jogadores
    SavePlayerInventory(player1)
    SavePlayerInventory(player2)

    -- Limpar inventário dos jogadores
    ClearPlayerInventory(player1)
    ClearPlayerInventory(player2)

    -- Teleportar jogadores para a dimensão de PvP
    SetPlayerRoutingBucket(player1, pvpDimension)
    SetPlayerRoutingBucket(player2, pvpDimension)

    -- Teleportar jogadores para a arena de PvP
    TriggerClientEvent('pvp:playerPrepared', player1, pvpCoords[1])
    TriggerClientEvent('pvp:playerPrepared', player2, pvpCoords[2])

    -- Adicionar itens aos jogadores
    AddItemsToPlayer(player1)
    AddItemsToPlayer(player2)

    -- Monitorar a morte dos jogadores
    MonitorPlayerDeaths(player1, player2)
end

-- Função para salvar o inventário do jogador
function SavePlayerInventory(playerId)
    local player = QBCore.Functions.GetPlayer(playerId)
    if player then
        playerInventories[playerId] = player.PlayerData.items
    end
end

-- Função para limpar o inventário do jogador
function ClearPlayerInventory(playerId)
    local player = QBCore.Functions.GetPlayer(playerId)
    if player then
        player.Functions.ClearInventory()
    end
end

-- Função para restaurar o inventário do jogador
function RestorePlayerInventory(playerId)
    local player = QBCore.Functions.GetPlayer(playerId)
    if player and playerInventories[playerId] then
        for _, item in ipairs(playerInventories[playerId]) do
            player.Functions.AddItem(item.name, item.amount, item.slot, item.info)
        end
        playerInventories[playerId] = nil
    end
end

-- Função para adicionar itens ao jogador
function AddItemsToPlayer(playerId)
    local player = QBCore.Functions.GetPlayer(playerId)
    if player then
        local allItemsAdded = true
        for _, item in ipairs(Config.Items) do
            local itemAdded = player.Functions.AddItem(item.name, item.amount)
            if not itemAdded then
                allItemsAdded = false
                print("Falha ao adicionar item " .. item.name .. " ao jogador " .. playerId) -- Debug
                break
            end
        end

        if allItemsAdded then
            -- Equipar a arma ao jogador
            TriggerClientEvent('pvp:equipWeapon', playerId, Config.Items[1].name, Config.Items[2].amount)
            print("Itens adicionados ao jogador " .. playerId .. " para PvP") -- Debug
        else
            print("Falha ao adicionar itens ao jogador " .. playerId) -- Debug
        end
    else
        print("Jogador não encontrado: " .. playerId) -- Debug
    end
end

-- Função para monitorar a morte dos jogadores
function MonitorPlayerDeaths(player1, player2)
    Citizen.CreateThread(function()
        while currentRound <= Config.MaxRounds do
            Citizen.Wait(0)
            if IsEntityDead(GetPlayerPed(GetPlayerFromServerId(player1))) or IsEntityDead(GetPlayerPed(GetPlayerFromServerId(player2))) then
                if currentRound < Config.MaxRounds then
                    RestartRound(player1, player2)
                    currentRound = currentRound + 1
                else
                    EndPVP(player1, player2)
                    break
                end
            end
        end
    end)
end

-- Função para reiniciar a rodada
function RestartRound(player1, player2)
    TriggerClientEvent('pvp:restartRound', player1, currentRound)
    TriggerClientEvent('pvp:restartRound', player2, currentRound)
    Citizen.Wait(5000)
    TriggerClientEvent('pvp:playerPrepared', player1, pvpCoords[1])
    TriggerClientEvent('pvp:playerPrepared', player2, pvpCoords[2])
    -- Adicionar itens aos jogadores novamente
    AddItemsToPlayer(player1)
    AddItemsToPlayer(player2)
end

-- Função para terminar o PvP
function EndPVP(player1, player2)
    TriggerClientEvent('pvp:endPVP', player1)
    TriggerClientEvent('pvp:endPVP', player2)
    playersInPVP[player1] = nil
    playersInPVP[player2] = nil
    currentRound = 0

    -- Restaurar inventário dos jogadores
    RestorePlayerInventory(player1)
    RestorePlayerInventory(player2)

    -- Teleportar jogadores de volta para a dimensão padrão
    SetPlayerRoutingBucket(player1, 0)
    SetPlayerRoutingBucket(player2, 0)
end

-- Evento para sair do PVP
RegisterNetEvent('pvp:exitPVP')
AddEventHandler('pvp:exitPVP', function()
    local playerId = source

    -- Verificar se o jogador está no PvP
    if playersInPVP[playerId] then
        -- Remover o jogador da tabela de jogadores no PvP
        playersInPVP[playerId] = nil

        -- Teleportar o jogador de volta ao NPC
        TriggerClientEvent('pvp:exitedPVP', playerId)

        -- Restaurar inventário do jogador
        RestorePlayerInventory(playerId)

        -- Teleportar jogador de volta para a dimensão padrão
        SetPlayerRoutingBucket(playerId, 0)
    else
        print("Jogador " .. playerId .. " tentou sair do PvP, mas não estava no PvP") -- Debug
    end
end)

-- Tarefa para notificar jogadores na fila a cada 30 segundos
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30000)  -- Espera 30 segundos
        NotifyQueueStatus()
    end
end)

-- Função para notificar jogadores na fila sobre o estado da fila
function NotifyQueueStatus()
    for _, playerId in ipairs(pvpQueue) do
        TriggerClientEvent('QBCore:Notify', playerId, "Ainda aguardando outro jogador para iniciar o PvP...", "info")
    end
end

RegisterNetEvent('pvp:equipWeapon')
AddEventHandler('pvp:equipWeapon', function(weaponName, ammoCount)
    local playerPed = PlayerPedId()
    local weaponHash = GetHashKey(weaponName)
    GiveWeaponToPed(playerPed, weaponHash, ammoCount, false, true)
end)