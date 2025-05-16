local t = Def.ActorFrame {
	OnCommand=cmd(playcommand,'StartSelectingSong');
}

t[#t+1] = LoadActor(THEME:GetPathG("","Common Resources/TIMER_MASK.png") )..{
	OnCommand=function(self)
		self:zoom(0.075)
		self:x(cx)
		self:y(22)
		self:play()
		self:MaskSource()
	end
}



t[#t+1] = Def.Sprite {
    Texture = THEME:GetPathG("", "Common Resources/TIMER_FRAME 5x8.jpg"),
    OnCommand = function(self)
        self:SetAllStateDelays(0.02) -- Tempo por frame (menor = mais rápido)
        self:setstate(0) -- começa do primeiro frame
        self:animate(true) -- ativa a animação automática

        self:zoom(0.325)
        self:x(cx)
        self:y(22)
        self:MaskDest()
    end
}

return t;