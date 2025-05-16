local t = Def.ActorFrame {
    OnCommand=function(self)
        self:queuecommand("UpdateSelection")
    end,
}

-- Verificação de segurança no início
if not CustomPrefs then
    CustomPrefs = {
        SaveGameMode = function(player, mode)
            -- Fallback básico
            GAMESTATE:Env()["GameMode"] = mode
            return false
        end,
        LoadGameMode = function(player)
            return GAMESTATE:Env()["GameMode"] or "Keyboard"
        end
    }
    Trace("CustomPrefs não encontrado, usando fallback")
end

-- Estado da seleção (1 = Keyboard, 2 = PumpPad)
local selectedMode = 1

-- Posições dos ícones
local iconPositions = {
    {x = SCREEN_CENTER_X-200, y = SCREEN_CENTER_Y},
    {x = SCREEN_CENTER_X+200, y = SCREEN_CENTER_Y}
}

-- Cursor (agora movível)
t[#t+1] = Def.Sprite {
    Texture=THEME:GetPathG("","ScreenSelectMode/cursor"),
    InitCommand=function(self)
        self:xy(iconPositions[1].x, iconPositions[1].y)
        self:zoom(0.5)
        self:playcommand("Loop")
    end,
    LoopCommand=function(self)
        self:stoptweening()
        self:diffusealpha(1)
        self:linear(.4)
        self:diffusealpha(.6)
        self:linear(.4)
        self:diffusealpha(1)
        self:queuecommand('Loop')
    end,
    UpdateSelectionCommand=function(self)
        self:finishtweening()
        self:linear(0.2)
        self:xy(iconPositions[selectedMode].x, iconPositions[selectedMode].y)
    end
}

-- Ícones interativos
t[#t+1] = Def.Sprite {
    Texture=THEME:GetPathG("", "ScreenSelectMode/Keyboard"),
    InitCommand=function(self)
        self:xy(iconPositions[1].x, iconPositions[1].y)
        self:zoom(0.5)
    end,
    UpdateSelectionCommand=function(self)
        self:stoptweening()
        self:linear(0.1)
        self:zoom(selectedMode == 1 and 0.7 or 0.5)
        self:diffuse(selectedMode == 1 and color("1,1,1,1") or color("0.5,0.5,0.5,0.7"))
    end
}

t[#t+1] = Def.Sprite {
    Texture=THEME:GetPathG("", "ScreenSelectMode/PumpPad"),
    InitCommand=function(self)
        self:xy(iconPositions[2].x, iconPositions[2].y)
        self:zoom(0.5)
    end,
    UpdateSelectionCommand=function(self)
        self:stoptweening()
        self:linear(0.1)
        self:zoom(selectedMode == 2 and 0.7 or 0.5)
        self:diffuse(selectedMode == 2 and color("1,1,1,1") or color("0.5,0.5,0.5,0.7"))
    end
}

-- Sistema de input via CodeMessage
local Players = GAMESTATE:GetHumanPlayers()
for player in ivalues(Players) do
    t[#t+1] = Def.Actor {
        CodeMessageCommand=function(self, params)
            if params.PlayerNumber == player then
                local previousMode = selectedMode
                
                if params.Name == "MenuRight" or params.Name == "DownRight" then
                    selectedMode = 2
                elseif params.Name == "MenuLeft" or params.Name == "DownLeft" then
                    selectedMode = 1
                elseif params.Name == "Start" or params.Name == "Center" then
                    -- Armazena a seleção globalmente
                        GAMESTATE:Env()["SelectedGameMode"] = (selectedMode == 1) and "Keyboard" or "PumpPad"
                    local mode = (selectedMode == 1) and "Keyboard" or "PumpPad"
                
                    -- Chamada segura:
                    if CustomPrefs and CustomPrefs.SaveGameMode then
                        CustomPrefs.SaveGameMode(player, mode)
                    else
                        -- Fallback emergencial
                        GAMESTATE:Env()["GameMode"] = mode
                    end
                    -- -- -- Alternativa adicional usando Profile
                    -- PROFILEMAN:GetProfile(player):SetPreference("GameMode", (selectedMode == 1) and "Keyboard" or "PumpPad")
                    
                    SOUND:PlayOnce(THEME:GetPathS("Common", "start"))
                    SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
                    
                elseif params.Name == "Back" then
                    SOUND:PlayOnce(THEME:GetPathS("Common", "back"))
                    SCREENMAN:GetTopScreen():Cancel()
                    
                end
                
                -- Atualiza apenas se o modo mudou
                if selectedMode ~= previousMode then
                    SOUND:PlayOnce(THEME:GetPathS("Common", "value"))
                    self:GetParent():playcommand("UpdateSelection")
                end
            end
        end,
    }
end

-- Texto de ajuda
t[#t+1] = LoadFont("Common Normal")..{
    Text="←/→: Selecionar Modo\nStart: Confirmar\nBack: Voltar",
    InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_BOTTOM-100;zoom,0.5;diffuse,color("0.8,0.8,0.8,1");shadowlength,1)
}

return t