local t = Def.ActorFrame {}

local arrayPosition = {1, 2, 3, 4, 8, 7, 6, 5} -- Itens na tela, apesar de aparecerem 7 a tela possui 8 itens (Banners)
-- Então criei esse Array pra garantir que os banners estejam sempre nessas posições. E sim, é essa sequencia torta mesmo 1,2,3,4,8,7,6,5
local positionIndex = 5 -- Posição inicial, que é o índice do valor central (8)
local firstPreviousActivation = true -- PreviousActivation tem estar em true ao iniciar
local firstNextActivation = false -- NextActivation tem q estar em false ao iniciar
local previousPositionItem -- Varíavel a ser utilizada nas funções
local isPrevious = false -- Verificador se a tecla de PreviousSong foi pressionada, inicia em false.
local yPositionBase = 345 -- Posição inicial da MusicWheel
 

-- A partir daqui foi um teste para tentar aproximar mais os banners pois eles ficam bem afastados...
-- Caso alguém tenha alguma ideia, podem mexer e testar. Comigo os Banners ficaram malucos.

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

-- Função para atualizar a posição e rotação dos itens (Antiga função, não deve mais funcionar)
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
-- !!! VERIFICAR POSIBILIDADE DE USAR O VALUE INVÉS DO BANNER !!!

-- Função para ajustar os banners na inicialização
local function AdjustBanners()
    local screen = SCREENMAN:GetTopScreen()
    local musicWheel = screen:GetChild("MusicWheel")
    if not musicWheel then return end
    musicWheel:zoom(1.1);
    local musicWheelItem = musicWheel:GetChild("MusicWheelItem")
    if not musicWheelItem then return end

    local index = tonumber(musicWheel:GetCurrentIndex())
    
    for key, value in pairs(musicWheelItem) do
        if tonumber(key) then
            local banner = value:GetChild("Banner")
            if banner then
                banner:stoptweening()
                banner:zoomto(115, 82) -- Tamanho correto (Phoenix)
                banner:rotationy(0) -- Resetar rotação para não ocorrer rotação de banner errado
                banner:y(0)
            end
        end
    end
end

-- Função para atualizar a MusicWheel e rotacionar o banner que está entrando no centro ao trocar de musica
local function RotationBanner(positionIndex, rotationY, isPrevious)
    AdjustBanners()
    local screen = SCREENMAN:GetTopScreen()
    local musicWheel = screen:GetChild("MusicWheel")
    local musicWheelItem = musicWheel:GetChild("MusicWheelItem")
    -- Determinar qual item está saindo do centro antes da mudança, sem esse comparativo os banners deslocam de posição
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
    for key, value in pairs(musicWheelItem) do
        if tonumber(key) == positionItem then
            local banner = value:GetChild("Banner")
            if banner then
                banner:finishtweening()
                banner:linear(.3)
                banner:y(25)
                banner:rotationy(banner:GetRotationY() + rotationY)
                banner:queuecommand("RepeatRotate")
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
end

local function ExitBanners() -- Função para saída dos Banners da tela
    local screen = SCREENMAN:GetTopScreen()
    local musicWheel = screen:GetChild("MusicWheel")
    local musicWheelItem = musicWheel:GetChild("MusicWheelItem")

    for key, value in pairs(musicWheelItem) do
        if firstNextActivation then
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

local function EnterBanners() -- Função para entrada dos Banners
    local screen = SCREENMAN:GetTopScreen()
    local musicWheel = screen:GetChild("MusicWheel")
    local musicWheelItem = musicWheel:GetChild("MusicWheelItem")

    for key, value in pairs(musicWheelItem) do
        if firstNextActivation then
            if tonumber(key) == arrayPosition[(positionIndex % #arrayPosition) + 1] then
                    local banner = value:GetChild("Banner")   
                    -- Bloco necessário se não a o efeito de retorno não funciona.      
                    musicWheel:stoptweening()
                    musicWheel:zoom(0)
                    musicWheel:y(345)
                    musicWheel:decelerate(.2)
                    musicWheel:y(345)
                    musicWheel:decelerate(.1)
                    musicWheel:y(345)

                    musicWheel:zoom(1.1)
                    -- Retorna o Banner pra posição, y(25) garante que o banner não desloque para baixo.
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
                -- Bloco necessário se não a o efeito de retorno não funciona.
                musicWheel:stoptweening()
                musicWheel:zoom(0)
                musicWheel:y(345)
                musicWheel:decelerate(.2)
                musicWheel:y(345)
                musicWheel:decelerate(.1)
                musicWheel:y(345)

                musicWheel:zoom(1.1)
                -- Retorna o Banner pra posição, y(25) garante que o banner não desloque para baixo.
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
    firstPreviousActivation = true -- Reset Previous Activation para garantir que as alterações de musica não alterem posições


end

-- Função para retroceder no array com percorrimento circular
local function PreviousSong()
    if firstPreviousActivation then
        firstPreviousActivation = false
        positionIndex = (positionIndex - 2 - 1) % #arrayPosition + 1-- Retrocede duas posições na primeira ativação
    else
        positionIndex = (positionIndex - 1 - 1) % #arrayPosition + 1 -- Retrocede uma posição subsequente
    end
    firstNextActivation = true -- Reset Next Activation para garantir que as alterações de musica não alterem posições
end


-- Adiciona o debug na tela
t[#t+1] = Def.ActorFrame {
        RepeatRotateCommand=function(self)
            self:linear(1)
            self:rotationy(0)
            self:rotationy(self:GetRotationY() + 360)
            self:queuecommand("RepeatRotate")
        end;
        OnCommand=function(self)
            RotationBanner(positionIndex, 0) -- Chamar RotationBanner na inicialização para garantir que o arrayPosition funcione
        end;
        CurrentSongChangedMessageCommand=function(self)
        end;
        NextSongMessageCommand=function(self)
            NextSong() -- Avança para a próxima posição
            RotationBanner(positionIndex, 360, false)
        end;
        PreviousSongMessageCommand=function(self)
            PreviousSong() -- Retrocede para a posição anterior
            RotationBanner(positionIndex, -360, true)
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


return t