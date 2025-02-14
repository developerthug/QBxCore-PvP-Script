-- Carregar configurações
local Config = Config or {}

-- Coordenadas do NPC
local npcCoords = Config.NPCCoords
local npcHeading = Config.NPCHeading
local npcModel = Config.NPCModel

-- Função para iniciar o NPC e configurar a interação
Citizen.CreateThread(function()
    RequestModel(npcModel)
    while not HasModelLoaded(npcModel) do
        Wait(500)
    end

    local npcPed = CreatePed(4, npcModel, npcCoords.x, npcCoords.y, npcCoords.z, npcHeading, false, true)
    FreezeEntityPosition(npcPed, true)
    SetEntityInvincible(npcPed, true)

    -- Adicionar interação com o NPC usando OxTarget
    exports['ox_target']:addEntity(npcPed, {
        label = "Vamos Trocar um tiro?",
        icon = 'fas fa-gun',
        action = function(entity)
            StartPVPDialogue()
        end
    })

    -- Loop para detectar a interação com a tecla E
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local dist = #(GetEntityCoords(playerPed) - npcCoords)

        if dist < 2.0 then
            DrawText3D(npcCoords.x, npcCoords.y, npcCoords.z + 1.0, Config.Texts.npcInteraction, 0.35)
            if IsControlJustPressed(0, 38) then
                StartPVPDialogue()
            end
        end
    end
end)

-- Função para iniciar o diálogo do PVP
function StartPVPDialogue()
    local options = {
        { 
            label = Config.Texts.menuOptions[1].label, 
            action = function()
                -- Chamar evento do servidor para adicionar jogador à fila de PvP ou iniciar o PvP diretamente
                if Config.UseQueue then
                    TriggerServerEvent('pvp:addToQueue')
                    print("Solicitação de PVP enviada ao servidor com fila") -- Debug
                else
                    TriggerServerEvent('pvp:startDirect')
                    print("Solicitação de PVP enviada ao servidor sem fila") -- Debug
                end
            end 
        },
        { 
            label = Config.Texts.menuOptions[2].label, 
            action = function()
                TriggerEvent('chat:addMessage', {
                    args = { "^2NPC:^7 Você é só um curioso, hein?" }
                })
            end 
        }
    }

    ShowDialog(options)
end

-- Função para mostrar o menu de diálogo
function ShowDialog(options)
    local selectedOption = 1
    local menuOpen = true

    Citizen.CreateThread(function()
        while menuOpen do
            Citizen.Wait(0)

            -- Desenhar fundo do menu
            DrawRect(0.5, 0.5, 0.4, 0.3, table.unpack(Config.Menu.backgroundColor))

            -- Desenhar título
            DrawText2D(Config.Texts.menuTitle, 0.5, 0.4, Config.Menu.titleScale, table.unpack(Config.Menu.titleColor))

            -- Desenhar opções
            for i, option in ipairs(options) do
                local yPos = 0.45 + (i * 0.05)
                local textColor = (selectedOption == i) and Config.Menu.optionColorSelected or Config.Menu.optionColorUnselected
                local prefix = (selectedOption == i) and "-> " or ""
                DrawText2D(prefix .. option.label, 0.35, yPos, Config.Menu.optionScale, table.unpack(textColor))
            end

            -- Navegação do menu
            if IsControlJustPressed(0, 172) then -- Seta para cima
                selectedOption = (selectedOption > 1) and selectedOption - 1 or #options
            elseif IsControlJustPressed(0, 173) then -- Seta para baixo
                selectedOption = (selectedOption < #options) and selectedOption + 1 or 1
            elseif IsControlJustPressed(0, 201) then -- Enter
                options[selectedOption].action()
                menuOpen = false
            end
        end
    end)
end

-- Função auxiliar para desenhar texto 2D
function DrawText2D(text, x, y, scale, r, g, b)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, 255)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

-- Função para desenhar texto 3D
function DrawText3D(x, y, z, text, scale)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    SetTextScale(scale, scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
end

-- Evento para receber confirmação do servidor e equipar itens
RegisterNetEvent('pvp:playerPrepared')
AddEventHandler('pvp:playerPrepared', function(coords)
    print("Evento pvp:playerPrepared recebido") -- Debug
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
    TriggerEvent('chat:addMessage', {
        args = { Config.Texts.pvpStartMessage }
    })
    -- Equipar a arma e a munição
    GiveWeaponToPed(PlayerPedId(), GetHashKey('weapon_pistol_mk2'), 250, false, true)
end)

-- Comando para sair do PVP
RegisterCommand('sairpvp', function()
    TriggerServerEvent('pvp:exitPVP')
end, false)

-- Evento para confirmar saída do PVP
RegisterNetEvent('pvp:exitedPVP')
AddEventHandler('pvp:exitedPVP', function()
    SetEntityCoords(PlayerPedId(), npcCoords.x, npcCoords.y, npcCoords.z, false, false, false, false)
    TriggerEvent('chat:addMessage', {
        args = { Config.Texts.pvpExitMessage }
    })
end)

-- Evento para reiniciar o PvP
RegisterNetEvent('pvp:restartRound')
AddEventHandler('pvp:restartRound', function(round)
    local playerPed = PlayerPedId()
    FreezeEntityPosition(playerPed, true)
    TriggerEvent('chat:addMessage', {
        args = { Config.Texts.pvpRoundStartMessage .. round .. " de " .. Config.MaxRounds }
    })
    Citizen.Wait(5000)
    FreezeEntityPosition(playerPed, false)
    TriggerEvent('chat:addMessage', {
        args = { Config.Texts.pvpRoundEndMessage }
    })
end)

-- Evento para finalizar o PvP
RegisterNetEvent('pvp:endPVP')
AddEventHandler('pvp:endPVP', function()
    SetEntityCoords(PlayerPedId(), npcCoords.x, npcCoords.y, npcCoords.z, false, false, false, false)
    TriggerEvent('chat:addMessage', {
        args = { Config.Texts.pvpEndMessage }
    })
end)