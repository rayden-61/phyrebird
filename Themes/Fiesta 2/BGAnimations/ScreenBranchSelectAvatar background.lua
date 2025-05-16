local t = Def.ActorFrame {};

t[#t+1] = LoadActor( BGDirB.."/Teaser" )..{
	InitCommand=cmd(FullScreen);	
};

t[#t+1] = Def.Quad {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,1;diffusealpha,0;linear,.1;diffusealpha,.4);
};

t[#t+1] = LoadFont("Common Normal")..{
	InitCommand=function(self)
		self:x(SCREEN_CENTER_X);
		self:y(SCREEN_CENTER_Y);
		if GetLanguageText() == "en" then
			self:settext("Loading Avatars");
		else
			self:settext("Cargando Avatars");
		end;
		(cmd(strokecolor,0,0,0,1;shadowlength,1))(self);
	end;
}

return t;
