local t = Def.ActorFrame {	
	ChangeStepsMessageCommand=function(self, params)
		if params.Direction == 1 then	--der
			--MESSAGEMAN:Broadcast("NextStep");
			self:playcommand("NextStep");
		elseif params.Direction == -1 then	--izq
			--MESSAGEMAN:Broadcast("PreviousStep");
			self:playcommand("PreviousStep");
		end;
	end;
}

local goback = cmd(stoptweening;diffusealpha,1;linear,.2;diffusealpha,0);
local start  = cmd(stoptweening;diffusealpha,0;sleep,.1;linear,.1;diffusealpha,1);
local init_black = cmd(stoptweening;diffusealpha,0;sleep,.3;diffusealpha,1);
local common = cmd(stoptweening;diffusealpha,0;linear,.1;diffusealpha,.5;linear,.2;diffusealpha,1);
local init_pink_for_basic = cmd(stoptweening;diffusealpha,0;linear,.1;diffusealpha,.5;linear,.2;diffusealpha,1;linear,.5;diffusealpha,0);
local shift_command = cmd(stoptweening;stopeffect;zoom,1;diffusealpha,.7;sleep,.15;linear,.15;diffusealpha,0;zoom,1.02;queuecommand,'Effect');

local zoom_factor = 0.66;
--local zoom_factor = 1;
----------------------------------------------------------------------------------------------------------------------------
--UpLeft--

local UL_ARROW = Def.ActorFrame {
	InitCommand=cmd(;x,35+135;y,35+135;zoom,zoom_factor);
	OnCommand=cmd(stoptweening;sleep,.1;linear,.1;x,35;y,35);
	OffCommand=cmd(stoptweening;x,35;y,35;sleep,.2;linear,.1;x,35+135;y,35+135;diffusealpha,.2;sleep,0;x,35;y,35;diffusealpha,1);
	children = {
		-- LoadActor( THEME:GetPathG("","ScreenSelectMusic/_Arrows/BASEN.png") )..{
		-- 	OnCommand=cmd(zoom,.25; x,-25; y,-28);
		-- };
		-- LoadActor( THEME:GetPathG("","ScreenSelectMusic/_Arrows/gray.png") )..{
		-- 	OnCommand=cmd(zoom, .50;);
		-- };
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/_Arrows/BASEPINK.png") )..{
			OnCommand=cmd(zoom,.25;  x,-25; y,-25;);
			GoBackSelectingGroupMessageCommand=cmd(stoptweening;diffusealpha,1;linear,.3;diffusealpha,0);
			StartSelectingSongMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,.3;diffusealpha,1);
		};
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/_Arrows/BASEPINK.png") )..{
			InitCommand=cmd(blend,'BlendMode_Add';rotationz,180;zoom,0.67;x,-25; y,-28;);
			OnCommand=cmd(finishtweening; zoom,.25; diffusealpha, 0.5; rotationz,0; linear, 1; rotationz,360; queuecommand,'Loop');
			LoopCommand=cmd(finishtweening;diffusealpha,1;rotationz,0;linear,1;diffusealpha, 0.5;rotationz,360;queuecommand,'Loop');
			GoBackSelectingGroupMessageCommand=cmd(stoptweening;diffusealpha,1;linear,.3;diffusealpha,0;);
			StartSelectingSongMessageCommand=cmd(stoptweening;diffusealpha,0;linear,.3;diffusealpha,1;queuecommand,'Loop');
		};
		-- LoadActor( THEME:GetPathG("","ScreenSelectMusic/_Arrows/back.png") ) .. {
		-- 	OnCommand=cmd(zoom,.25; x,-35; y,-35);
		-- 	BaseRotationZ=-45;
		-- };
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/_Arrows/UpLeft 4x2.png") )..{
			OnCommand=cmd(zoom, .60;);
			GoBackSelectingGroupMessageCommand=cmd(stoptweening;diffusealpha,1;linear,.3;diffusealpha,0);
			StartSelectingSongMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,.3;diffusealpha,1);
		};

	};
}
	local delta = 340;

local UR_ARROW = Def.ActorFrame {
	InitCommand=cmd(x,SCREEN_WIDTH-35-135;y,35+135;zoom,zoom_factor);
	OnCommand=cmd(stoptweening;sleep,.1;linear,.1;x,SCREEN_WIDTH-35;y,35);
	OffCommand=cmd(stoptweening;x,SCREEN_WIDTH-35;y,35;sleep,.2;linear,.1;x,SCREEN_WIDTH-35-135;y,35+135;diffusealpha,.2;sleep,0;x,SCREEN_WIDTH-35;y,35;diffusealpha,1);
	children = {
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/_Arrows/BASEN.png") )..{
			BaseRotationY=180;
			OnCommand=cmd(zoom,.25; x,25; y,-25);
		};
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/_Arrows/gray.png") )..{
			OnCommand=cmd(zoom, .50;);
			BaseRotationY=180;
		};
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/_Arrows/BASEPINK.png") )..{
			BaseRotationY=180;
			OnCommand=cmd(zoom,.25; x,25; y,-25);
			GoBackSelectingGroupMessageCommand=cmd(stoptweening;diffusealpha,1;linear,.3;diffusealpha,0);
			StartSelectingSongMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,.3;diffusealpha,.8);
		};
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/_Arrows/UpLeft 4x2.png") )..{
			BaseRotationY=180;
			OnCommand=cmd(zoom, .50;);
			GoBackSelectingGroupMessageCommand=cmd(stoptweening;diffusealpha,1;linear,.3;diffusealpha,0);
			StartSelectingSongMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,.3;diffusealpha,.8);
		};
	};
}

local blue_arrows_shine_shift = cmd(stoptweening;diffusealpha,0;zoomy,1;zoomx,1;sleep,.1;linear,.1;diffusealpha,.6;linear,.2;zoomy,.5;zoomx,1.5;diffusealpha,0);
local blue_arrows_graph_shift = cmd(stoptweening;stopeffect;diffusealpha,.1;zoom,1.08;linear,.2;diffusealpha,.5;zoom,1.1;linear,.2;diffusealpha,0;zoom,1.08;queuecommand,'ContinueEffect');

local DR_ARROW = Def.ActorFrame {
	InitCommand=cmd(x,SCREEN_WIDTH-35-135;y,SCREEN_HEIGHT-35-135;zoom,zoom_factor);
	OnCommand=cmd(stoptweening;sleep,.1;linear,.1;x,SCREEN_WIDTH-35;y,SCREEN_HEIGHT-36);
	OffCommand=cmd(stoptweening;x,SCREEN_WIDTH-35;y,SCREEN_HEIGHT-36;sleep,.2;linear,.1;x,SCREEN_WIDTH-35-135;y,SCREEN_HEIGHT-35-135;diffusealpha,.2;sleep,0;x,SCREEN_WIDTH-35;y,SCREEN_HEIGHT-36;diffusealpha,1);
	children = {
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/_Arrows/BASEBLUE.png") )..{
			BaseRotationY=180;
			OnCommand=cmd(zoom,.25;x, 25;y,25);
		};
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/_Arrows/DownLeft 4x2.png") )..{
			BaseRotationY=180;
			OnCommand=cmd(zoom,.50);
		};
	};
}

local DL_ARROW = Def.ActorFrame {
	InitCommand=cmd(x,35+135;y,SCREEN_HEIGHT-35-135;zoom,zoom_factor);
	OnCommand=cmd(stoptweening;sleep,.1;linear,.1;x,35;y,SCREEN_HEIGHT-35);
	OffCommand=cmd(stoptweening;x,35;y,SCREEN_HEIGHT-35;sleep,.2;linear,.1;x,35+135;y,SCREEN_HEIGHT-35-135;diffusealpha,.2;sleep,0;x,35;y,SCREEN_HEIGHT-35;diffusealpha,1);
	children = {
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/_Arrows/BASEBLUE.png") )..{
			OnCommand=cmd(zoom,.25;x, -25;y,25);
		};
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/_Arrows/DownLeft 4x2.png") )..{
			OnCommand=cmd(zoom,.50);
		};
	};
}

t[#t+1] = UL_ARROW;
t[#t+1] = UR_ARROW;
t[#t+1] = DR_ARROW;
t[#t+1] = DL_ARROW;

return t;