return Def.ActorFrame {
	LoadActor( BGDirB.."/Teaser" )..{
		InitCommand=cmd(FullScreen);
	};
	Def.Quad {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,1;diffusealpha,.5;linear,1;diffusealpha,.8);
	};
	LoadActor( THEME:GetPathG("","ScreenSelectAvatar/mask") )..{
		InitCommand=cmd(horizalign,'HorizAlign_Right';x,SCREEN_RIGHT;y,SCREEN_CENTER_Y;blend,'BlendMode_NoEffect';zwrite,true);
	};
};
