local t = Def.ActorFrame {}
-- Vídeo de fundo
t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("", "CommonBackground/BACK.mpg"),
    OnCommand=function(self)
        self:stretchto(SCREEN_LEFT, SCREEN_TOP, SCREEN_RIGHT, SCREEN_BOTTOM)
        self:play()
        self:loop(true)
    end
}

-- Música de fundo (loop)
t[#t+1] = Def.Sound{
    File=THEME:GetPathS("", "Sounds/MODESELECT.mp3"), -- coloque o nome certo do arquivo aqui
    OnCommand=function(self)
        self:play()
    end
}

return t