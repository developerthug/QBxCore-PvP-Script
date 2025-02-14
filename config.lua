Config = {}

-- Coordenadas do NPC
Config.NPCCoords = vector3(-1750.68, 3011.79, 32.81)
Config.NPCHeading = 153.0
Config.NPCModel = "s_m_y_marine_03"  -- Modelo de soldado do exército

-- Coordenadas da arena de PVP
Config.PVPCoords = {
    vector3(-1904.3, 3162.49, 474.64),  -- Spawn do jogador 1
    vector3(-1903.5, 3201.91, 474.64)   -- Spawn do jogador 2
}

-- Itens a serem dados ao jogador
Config.Items = {
    { name = 'weapon_pistol_mk2', amount = 1 },
    { name = 'ammo-9', amount = 250 }
}

-- Número máximo de rodadas
Config.MaxRounds = 8

-- Ativar ou desativar a funcionalidade de fila
Config.UseQueue = false

-- Configurações de texto
Config.Texts = {
    npcInteraction = "Pressione ~g~E~w~ para interagir",
    menuTitle = "Escolha sua opção",
    menuOptions = {
        { label = "Sim, gostaria de ir ao PVP." },
        { label = "Não, apenas sou um curioso achando legal um Soldado Falante!!" }
    },
    pvpStartMessage = "^2Sistema:^7 Você foi teleportado para a arena de PVP!",
    pvpEndMessage = "^2Sistema:^7 O PvP terminou. Você foi devolvido ao NPC.",
    pvpExitMessage = "^2Sistema:^7 Você saiu da arena de PVP e retornou ao NPC.",
    pvpRoundStartMessage = "^2Sistema:^7 Nova rodada começará em 5 segundos. Rodada ",
    pvpRoundEndMessage = "^2Sistema:^7 A rodada começou!"
}

-- Configurações do menu
Config.Menu = {
    backgroundColor = {0, 0, 0, 180},
    titleColor = {255, 255, 255},
    titleScale = 0.6,
    optionColorSelected = {0, 255, 0},
    optionColorUnselected = {200, 200, 200},
    optionScale = 0.4
}