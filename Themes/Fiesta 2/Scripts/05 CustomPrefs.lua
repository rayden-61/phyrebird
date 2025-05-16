-- Themes/Fiesta 2/Scripts/CustomPrefs.lua
local CustomPrefs = {}

function CustomPrefs.SaveGameMode(player, mode)
    -- Método para Simply Love
    local profile = PROFILEMAN:GetProfile(player)
    if profile and profile.SetSaved then
        profile:SetSaved("GameMode", mode)
        return true
    end
    
    -- Método alternativo para outras versões
    GAMESTATE:Env()["GameMode_"..ToEnumShortString(player)] = mode
    return false
end

function CustomPrefs.LoadGameMode(player)
    -- Tenta carregar do Simply Love primeiro
    local profile = PROFILEMAN:GetProfile(player)
    if profile and profile.GetSaved then
        return profile:GetSaved("GameMode") or "Keyboard"
    end
    
    -- Fallback para env
    return GAMESTATE:Env()["GameMode_"..ToEnumShortString(player)] or "Keyboard"
end

-- Torna a tabela global
_G.CustomPrefs = CustomPrefs