local QBCore = exports['qb-core']:GetCoreObject()
local activeEffectHandle = nil

-- Configuração centralizada dos drinks
local drinksConfig = {
    {type = "Kire", effect = "fire_wrecked_rc", message = "Você fica com tesão.", image = "imagens/kire.png", emote = "lapchair"},
    {type = "Elyndor", effect = "ent_anim_hen_flee", message = "Você só conta a verdade.", image = "imagens/elyndor.png", emote = "nervous3"},
    {type = "Kalisto", effect = "ent_anim_blown_radiator", message = "Você fica mal humorado e sarcástico.", image = "imagens/kalisto.png", emote = "flipoff"},
    {type = "Solan", effect = "veh_exhaust_afterburner", message = "Você fica extremamente positivo.", image = "imagens/solan.png", emote = "flip", scale = 0.6},
    {type = "Gaia", effect = "ent_amb_falling_cherry_bloss", message = "Você fica afetuoso e simpático.", image = "imagens/gaia.png", emote = "hug3", scale = 2.5},
    {type = "Fenris", effect = "ent_dst_elec_fire", message = "Você fica com raiva.", image = "imagens/fenrir.png", emote = "beast"},
    {type = "Valen", effect = "scrape_blood", message = "Você fica enjoado.", image = "imagens/valen.png", emote = "outofbreath"},
    {type = "Nerissa", effect = "ent_amb_sewer_drips_med", message = "Você fica extremamente triste.", image = "imagens/nerissa_teseu.png", emote = "fallasleep", scale = 2.5},
    {type = "Teseu", effect = "ent_amb_sewer_drips_med", message = "Você fica extremamente triste.", image = "imagens/nerissa_teseu.png", emote = "fallasleep", scale = 2.5}
}

-- Função para limpar efeitos e notificações
local function ClearAllEffects()
    local playerPed = PlayerPedId()
    ClearPedTasksImmediately(playerPed)
    if activeEffectHandle then
        StopParticleFxLooped(activeEffectHandle, 0)
        activeEffectHandle = nil
    end
    SendNUIMessage({type = "reset"})
end

-- Função para aplicar efeitos de um drink
local function ApplyDrinkEffect(drink)
    ClearAllEffects()

    local playerPed = PlayerPedId()

    -- Inicia a animação de beber
    TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_DRINKING', 0, true)
    PlaySoundNUI("audio1")  -- Som da animação de beber
    Citizen.Wait(8000)  -- Tempo da animação principal
    ClearPedTasksImmediately(playerPed)

    -- Notificação e som de efeito
    PlaySoundNUI("audio2")
    ShowNotificationNUI(drink.message, drink.image)

    -- Aplica o efeito visual
    UseParticleFxAssetNextCall('core')
    local scale = drink.scale or 1.0 -- Usa escala padrão se não configurada
    activeEffectHandle = StartParticleFxLoopedOnEntity(
        drink.effect,
        playerPed,
        0.0, 0.0, 1.2,  -- Posição fixa
        0.0, 0.0, 0.0,  -- Rotação
        scale,          -- Escala
        false, false, false
    )
    
    -- Executa emote, se existir
    if drink.emote then
        ExecuteCommand("e " .. drink.emote)
    end

    -- Aguarda o tempo do efeito
    Citizen.Wait(52000)

    -- Remove efeitos e notificações
    ClearAllEffects()
end

-- Comando para ativar drink aleatório
RegisterCommand('drinkmagic', function()
    local randomIndex = math.random(1, #drinksConfig)
    local randomDrink = drinksConfig[randomIndex]
    ApplyDrinkEffect(randomDrink)
end, false)

-- Funções NUI
function PlaySoundNUI(soundName)
    SendNUIMessage({type = "playSound", sound = soundName})
end

function ShowNotificationNUI(message, image)
    SendNUIMessage({type = "notification", message = message, image = image})
end
