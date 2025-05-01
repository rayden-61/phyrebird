local t = Def.ActorFrame {}

local debugMessages = {} -- Lista para armazenar mensagens de debug
local maxDebugLines = 20 -- Número máximo de mensagens visíveis na tela

-- Função para adicionar mensagens ao debug
local function AddDebugMessage(text)
    if debugMessages[#debugMessages] ~= text then -- Verifica se a nova mensagem é diferente da última mensagem
        table.insert(debugMessages, text) -- Adiciona nova mensagem
        if #debugMessages > maxDebugLines then
            table.remove(debugMessages, 1) -- Remove a mais antiga se passar do limite
        end
    end
end

-- Função para atualizar o texto de debug com as mensagens
local function UpdateDebugText(debugTextActor)
    local msg = table.concat(debugMessages, "\n")
    debugTextActor:settext(msg)
end

local arrayPosition = {1, 2, 3, 4, 8, 7, 6, 5}
local positionIndex = 5 -- Posição inicial, que é o índice do valor central (8)
local firstPreviousActivation = true
local firstNextActivation = false
local previousPositionItem
local isPrevious = false

-- local offsets = {
--     -- [4] = { x = 145, rotation = 45 },

--     -- [2] = {x = 0, rotation = 0 }, -- (Posição +3 da direita)
--     -- [1] = { x = 80, rotation = 45 }, -- (Posição +2 da direita)
--     -- [0] = { x = 145, rotation = 50 }, -- (Posição +1 da direita)
--     -- [3] = { x = 215, rotation = 55,}, -- Posição Central 
--     -- [-1] = { x = -80, rotation = -45 }, -- (Posição -1 da Esquerda)
--     -- [-2] = { x = -145, rotation = -50 }, -- (Posição -2 da Esquerda)
--     -- [-3] = { x = -215, rotation = -55 }, -- (Posição -3 da Esquerda)
    
--     [1] = { x = -215, rotation = -55 }, -- (-3 da Esquerda)
--     [2] = { x = -145, rotation = -50 }, -- (-2 da Esquerda)
--     [3] = { x = -80, rotation = -45 }, -- (-1 a Esquerda)

--     [-3] = { x = 80, rotation = 45}, -- (+1 a Direita)
--     [-2] = { x = 145, rotation = 50 }, -- (+2 a Direita)
--     [-1] = { x = 215, rotation = 55 }, -- (+3 a Direita)
-- }

-- local function RefreshBanners()
--     local screen = SCREENMAN:GetTopScreen()
--     local musicWheel = screen:GetChild("MusicWheel")
--     local musicWheelItem = musicWheel:GetChild("MusicWheelItem")

--     for key, value in pairs(musicWheelItem) do
--         local keyNumber = tonumber(key)
    
--         -- Encontra o índice do item dentro do arrayPosition
--         local indexInArray = nil
--         for i, v in ipairs(arrayPosition) do
--             if v == keyNumber then
--                 indexInArray = i
--                 break
--             end
--         end
    
--         if indexInArray then
--             -- Calcula a posição relativa ao centro
--             local relativePosition = (indexInArray - positionIndex) % #arrayPosition
            
--             -- Ajusta o offset com base na posição
--             local offsetIndex = relativePosition - math.ceil(#arrayPosition / 2)
    
--             -- Checa se há um valor de offset para essa posição
--             local params = offsets[offsetIndex]
    
--             if params then
--                 local banner = value:GetChild("Banner")
    
--                 -- Atualiza a posição e rotação dos banners
                
--                 value:x(params.x)
--                 value:rotationy(params.rotation)
--             else
--                 -- Se não houver offset, mantém o item centralizado
--                     value:x(0)
--                     value:rotationy(0)
--             end
--         end
--     end
-- end

-- Função para atualizar a posição e rotação dos itens
-- function UpdateItemPositions()
--     local screen = SCREENMAN:GetTopScreen()
--     local musicWheel = screen:GetChild("MusicWheel")
--     local musicWheelItem = musicWheel:GetChild("MusicWheelItem")
    
--     for key, value in pairs(MusicWheelItem) do
--         -- Verifica se o item existe para a chave 'key'
--         if value then
--             -- Atualiza a posição e rotação do item
--             value:x(offsets[key].x)
--             value:rotation(offsets[key].rotation)
--         end
--     end
-- end
-- VERIFICAR POSIBILIDADE DE USAR O VALUE INVÉS DO BANNER 
-- VERIFICAR A SAIDA DA MUSICWHEEL DA TELA E O ITEM ATIVO NÃO SUBIR QUANDO FOR SELECIONADO

-- Função para ajustar os banners na inicialização
local function AdjustBanners()
    local screen = SCREENMAN:GetTopScreen()
    local musicWheel = screen:GetChild("MusicWheel")
    if not musicWheel then return end
    musicWheel:zoom(1.1);
    local musicWheelItem = musicWheel:GetChild("MusicWheelItem")
    if not musicWheelItem then return end

    -- AddDebugMessage("---> " .. tostring(screen) .. " no Index: " .. tostring(musicWheel:GetCurrentIndex()))
    local index = tonumber(musicWheel:GetCurrentIndex())
    

    for key, value in pairs(musicWheelItem) do
        if tonumber(key) then
            local banner = value:GetChild("Banner")
            if banner then
                banner:stoptweening()
                banner:zoomto(115, 82) -- Tamanho correto
                banner:rotationy(0) -- Resetar rotação
                banner:y(0)
            end
        end
    end


end

-- Função para atualizar a MusicWheel
local function RotationBanner(positionIndex, rotationY, isPrevious)
    AdjustBanners()
    local screen = SCREENMAN:GetTopScreen()
    local musicWheel = screen:GetChild("MusicWheel")
    local musicWheelItem = musicWheel:GetChild("MusicWheelItem")
    -- Determinar qual item está saindo do centro antes da mudança
        local previousPositionIndex
        if isPrevious then
                previousPositionIndex = (positionIndex + 1) % #arrayPosition
        else
                previousPositionIndex = (positionIndex - 1) % #arrayPosition
        end

        if previousPositionIndex < 1 then
            previousPositionIndex = #arrayPosition + previousPositionIndex
        end
    
        local positionItem = arrayPosition[positionIndex]
        local previousPositionItem = arrayPosition[previousPositionIndex] -- Item que estava no centro antes    
    -- AddDebugMessage("Position Item na posição: " .. positionItem)
    for key, value in pairs(musicWheelItem) do
        if tonumber(key) == positionItem then
            -- AddDebugMessage("Key= " .. tonumber(key) .. " positionItem= " .. positionItem)
            local banner = value:GetChild("Banner")
            if banner then
                --AddDebugMessage("Banner encontrado na posição " .. tostring(key))
                banner:finishtweening()
                banner:linear(.3)
                banner:y(25)
                banner:rotationy(banner:GetRotationY() + rotationY)
                banner:queuecommand("RepeatRotate")

                --AddDebugMessage("Banner do item central girando")
            end
        elseif tonumber(key) == previousPositionItem then
            -- O item que está saindo do centro: faz a transição suave para Y(0)
            local banner = value:GetChild("Banner")
            if banner then 
                banner:finishtweening()
                banner:y(25)
                banner:linear(.3)
                banner:y(0)
            end
            
        end
    end
    AddDebugMessage("---> " .. tostring(screen) .. " no Index: " .. tostring(musicWheel:GetCurrentIndex()))

end

local function ExitBanners() 
    local screen = SCREENMAN:GetTopScreen()
    local musicWheel = screen:GetChild("MusicWheel")
    local musicWheelItem = musicWheel:GetChild("MusicWheelItem")

    for key, value in pairs(musicWheelItem) do
        if firstNextActivation then
            -- AddDebugMessage(">>>> " .. positionIndex)
            if tonumber(key) == arrayPosition[(positionIndex + 1 - 1) % #arrayPosition + 1] then
                local banner = value:GetChild("Banner")
                if banner then
                    banner:finishtweening()
                    banner:y(25)  -- Força a posição antes da animação
                    banner:zoomto(115, 82)
                    banner:linear(0.3)
                    banner:zoomto(0, 0)
                end
            end
            if tonumber(key) == arrayPosition[positionIndex] then
                local banner = value:GetChild("Banner")
                if banner then
                    banner:finishtweening()
                    banner:y(0) -- Reseta a posição antes de qualquer outro efeito
                    banner:linear(0.1)
                    banner:y(0)

                end
            end
        elseif firstPreviousActivation then
            if tonumber(key) == arrayPosition[positionIndex]  then
                local banner = value:GetChild("Banner")
                if banner then
                    banner:finishtweening()
                    banner:y(25) -- Reseta para posição correta
                    banner:zoomto(115, 82)
                    banner:linear(0.3)
                    banner:zoomto(0, 0)
                end
            end
        end
    end

end

local function EnterBanners() 

    local screen = SCREENMAN:GetTopScreen()
    local musicWheel = screen:GetChild("MusicWheel")
    local musicWheelItem = musicWheel:GetChild("MusicWheelItem")

    for key, value in pairs(musicWheelItem) do
        if firstNextActivation then
            if tonumber(key) == arrayPosition[(positionIndex % #arrayPosition) + 1] then
                    local banner = value:GetChild("Banner")   

                    musicWheel:stoptweening()
                    musicWheel:zoom(0)
                    musicWheel:y(SCREEN_HEIGHT-118+180)
                    musicWheel:decelerate(.2)
                    musicWheel:y(SCREEN_HEIGHT-118-10)
                    musicWheel:decelerate(.1)
                    musicWheel:y(SCREEN_HEIGHT-118)

                    musicWheel:zoom(1.1)
                    
                    banner:y(0)
                    banner:zoomto(0,0)
                    banner:decelerate(.2)
                    banner:zoomto(57.5, 41)
                    banner:decelerate(.1)
                    banner:zoomto(115, 82)
                    banner:y(25)
            end
            
        elseif firstPreviousActivation then
            if tonumber(key) == arrayPosition[positionIndex] then
                local banner = value:GetChild("Banner")   

                musicWheel:stoptweening()
                musicWheel:zoom(0)
                musicWheel:y(SCREEN_HEIGHT-118+180)
                musicWheel:decelerate(.2)
                musicWheel:y(SCREEN_HEIGHT-118-10)
                musicWheel:decelerate(.1)
                musicWheel:y(SCREEN_HEIGHT-118)

                musicWheel:zoom(1.1)
                
                banner:zoomto(0,0)
                banner:decelerate(.2)
                banner:zoomto(57.5, 41)
                banner:decelerate(.1)
                banner:zoomto(115, 82)
            end
        end
    end

end

-- Função para avançar no array com percorrimento circular
local function NextSong()
    if firstNextActivation then
        firstNextActivation = false
        positionIndex = (positionIndex + 2 - 1) % #arrayPosition + 1 -- Avança duas posições na primeira ativação
    else
        positionIndex = (positionIndex + 1 - 1) % #arrayPosition + 1 -- Avança uma posição subsequente
    end
    firstPreviousActivation = true -- Reset Previous Activation to handle alternating correctly


end

-- Função para retroceder no array com percorrimento circular
local function PreviousSong()
    if firstPreviousActivation then
        firstPreviousActivation = false
        positionIndex = (positionIndex - 2 - 1) % #arrayPosition + 1-- Retrocede duas posições na primeira ativação
    else
        positionIndex = (positionIndex - 1 - 1) % #arrayPosition + 1 -- Retrocede uma posição subsequente
    end
    firstNextActivation = true -- Reset Next Activation to handle alternating correctly



end

-- t[#t+1] =  Def.ActorFrame{
-- 	Def.Banner{
-- 		InitCommand=cmd(scaletoclipped,165,125);
-- 		SetMessageCommand=function(self,params)
-- 			local song = params.Song;
-- 			self:LoadFromSongBanner( song );
-- 			-- 
-- 		end;
		
-- 	OnCommand=cmd(zoomx,10;sleep,0.1;decelerate,0.2;zoomx,1;);
-- 	SongChosenMessageCommand=cmd(stoptweening;zoom,1;sleep,0.05;decelerate,0.25;zoom,0;sleep,3;diffusealpha,0);
-- 	SongUnchosenMessageCommand=cmd(stoptweening;zoom,0;sleep,0.1;accelerate,0.2;zoom,1;diffusealpha,1);
-- 	ChannelScrollerActiveMessageCommand=cmd(;stoptweening;zoomx,1;sleep,0.05;zoomx,1;accelerate,0.1;zoomx,10;decelerate,0.1;zoom,0;visible,false);
-- 	ChannelScrollerInactiveMessageCommand=cmd(;stoptweening;zoom,0;sleep,0.05;zoom,1;zoomx,0.5;sleep,0.1;linear,0.2;zoomx,1;visible,true);
-- 	ChannelChosenMessageCommand=cmd(visible,true);
-- 	SelectChannelMessageCommand=cmd(visible,false);
-- 	};
-- 	LoadActor("BOX") .. {
-- 		InitCommand=cmd(animate,false;setsize,175,140);
-- 			OnCommand=cmd(zoomx,10;sleep,0.1;decelerate,0.2;zoomx,1;);
-- 	SongChosenMessageCommand=cmd(stoptweening;zoom,1;sleep,0.05;decelerate,0.25;zoom,0;);
-- 	SongUnchosenMessageCommand=cmd(stoptweening;zoom,0;sleep,0.1;accelerate,0.2;zoom,1;);
-- 	ChannelScrollerActiveMessageCommand=cmd(stoptweening;zoomx,1;sleep,0.05;zoomx,1;accelerate,0.1;zoomx,10;decelerate,0.1;zoom,0;);
-- 	ChannelScrollerInactiveMessageCommand=cmd(stoptweening;zoom,0;sleep,0.05;zoom,1;zoomx,0.5;sleep,0.1;linear,0.2;zoomx,1;);
-- 	ChannelChosenMessageCommand=cmd(visible,true);
-- 	SelectChannelMessageCommand=cmd(visible,false);
-- 	};
-- };



-- Adiciona o debug na tela
t[#t+1] = Def.ActorFrame {
    LoadFont("_century gothic 20px")..{
        Name="DebugText";
        -- Text="Debug: Iniciando...";
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X - 350, SCREEN_TOP + 120)
            self:zoom(0.5)
            -- self:settext("Carregando...")
            self:halign(0)
            self:draworder(100)
            -- AddDebugMessage("Debug do OnCommand")
            --     UpdateDebugText(self)
        end;
        RepeatRotateCommand=function(self)
            self:linear(1)
            self:rotationy(0)
            self:rotationy(self:GetRotationY() + 360)
            self:queuecommand("RepeatRotate")
        end;
        OnCommand=function(self)
            RotationBanner(positionIndex, 0) -- Chamar RotationBanner na inicialização para garantir que o arrayPosition funcione
            -- RefreshBanners()
            -- UpdateDebugText(self)
        end;
        CurrentSongChangedMessageCommand=function(self)
            -- UpdateDebugText(self)
        end;
        NextSongMessageCommand=function(self)
            -- UpdateDebugText(self)
            NextSong() -- Avança para a próxima posição
            RotationBanner(positionIndex, 360, false)
            -- AddDebugMessage("Valor de PositionIndex: " .. tostring(positionIndex))
            -- UpdateDebugText(self)
            -- RefreshBanners()
        end;
        PreviousSongMessageCommand=function(self)
            -- UpdateDebugText(self)
            PreviousSong() -- Retrocede para a posição anterior
            RotationBanner(positionIndex, -360, true)
            -- AddDebugMessage("Valor de PositionIndex: " .. tostring(positionIndex))
            -- UpdateDebugText(self)
            -- RefreshBanners()
        end;
        StartSelectingStepsMessageCommand=function(self)
            ExitBanners() 
        end;
        GoBackSelectingSongMessageCommand=function(self)
            EnterBanners()
            -- RefreshBanners()
        end;
        StartSelectingSongMessageCommand=function(self)
            EnterBanners()
            -- RefreshBanners()
        end;
        GoBackSelectingGroupMessageCommand=function(self)
            ExitBanners()
        end;
    };
};


return t