local t = Def.ActorFrame {}



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


t[#t+1] = Def.ActorProxy {
	BeginCommand=function(self) 
		local Timer = SCREENMAN:GetTopScreen():GetChild('Timer'); 
		self:SetTarget(Timer); 
	end,
	OnCommand=function(self)
		self:x(SCREEN_CENTER_X)
		self:y(20)
		self:basezoom(.66)
		self:zoom(0)
		self:sleep(2)
		self:linear(.05)
		self:zoom(1);
	end,
	OffCommand=function(self)
		self:finishtweening()
		self:zoom(1)
		self:linear(2)
		self:zoom(0);
	end
}

return t;