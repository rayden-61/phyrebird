-- Index para el cursor
local item_index = 1;
-- Item para los profiles
local cur_item = 0;
-- Total avatares
local total_avatars = 249;
--local total_avatars = 222;
--local total_avatars = 128;

local ZeroProfiles = false;
if PROFILEMAN:GetNumLocalProfiles() == 0 then
	ZeroProfiles = true;
end;	

local state = { Profile = "SelectingProfile", Avatar = "SelectingAvatar" };
local CurState = state.Profile;

local IsConfirm = false;

local t = Def.ActorFrame {
	CodeMessageCommand=function(self,params)
		if ( params.Name == "Back" ) then
			if CurState == state.Avatar then
				CurState = state.Profile;
				MESSAGEMAN:Broadcast("GoBack"..CurState);
				return;
			end;
			if CurState == state.Profile then
				SCREENMAN:GetTopScreen():FinishSelectingAvatar();
				return;
			end;
		end;
		------------------
		if ZeroProfiles then
			SOUND:PlayOnce(THEME:GetPathS("","Sound/BAD"));
			return;
		end;
		------------------
		if ( params.Name == "Center" or params.Name == "Start" ) then
			if CurState == state.Profile then
				CurState = state.Avatar;
				MESSAGEMAN:Broadcast("Start"..CurState);
				SOUND:PlayOnce(THEME:GetPathS("","2-1.ogg"));
				return;
			end;
			if CurState == state.Avatar then
				if not IsConfirm then
					IsConfirm = true;
					MESSAGEMAN:Broadcast("ConfirmAvatar");
					SOUND:PlayOnce(THEME:GetPathS("","Sounds/CENTER.mp3"));
				return; end;
				if IsConfirm then
					IsConfirm = false;
					CurState = state.Profile;
					WriteAvatarID(cur_item,item_index);
					MESSAGEMAN:Broadcast("GoBack"..CurState);
					SOUND:PlayOnce(THEME:GetPathS("","2-1.ogg"));
				return; end;
			end;
		end;
		if( params.Name == "Up" and CurState == state.Profile ) then
			MESSAGEMAN:Broadcast("PrevProfile");
			SOUND:PlayOnce(THEME:GetPathS("","CW/S_CMD_MOVE.WAV"));
			return;
		end;
		if ( params.Name == "Down" and CurState == state.Profile ) then
			MESSAGEMAN:Broadcast("NextProfile");
			SOUND:PlayOnce(THEME:GetPathS("","CW/S_CMD_MOVE.WAV"));
			return;
		end;	
		if ( params.Name == "DownLeft" or params.Name == "Left" ) then
			if CurState == state.Profile then
				MESSAGEMAN:Broadcast("PrevProfile");
				SOUND:PlayOnce(THEME:GetPathS("","CW/S_CMD_MOVE.WAV"));
				return;
			end;
			if CurState == state.Avatar then
				IsConfirm = false;
				MESSAGEMAN:Broadcast("LeftAvatar");
				MESSAGEMAN:Broadcast("DisconfirmAvatar");
				SOUND:PlayOnce(THEME:GetPathS("","CW/S_CMD_MOVE.WAV"));
				return;
			end;
		end;
		if ( params.Name == "DownRight" or params.Name == "Right" ) then
			if CurState == state.Profile then
				MESSAGEMAN:Broadcast("NextProfile");
				SOUND:PlayOnce(THEME:GetPathS("","CW/S_CMD_MOVE.WAV"));
				return;
			end;
			if CurState == state.Avatar then
				IsConfirm = false;
				MESSAGEMAN:Broadcast("RightAvatar");
				MESSAGEMAN:Broadcast("DisconfirmAvatar");
				SOUND:PlayOnce(THEME:GetPathS("","CW/S_CMD_MOVE.WAV"));
				return;
			end;
		end;
		if ( params.Name == "HoldDownLeft" or params.Name == "HoldLeft" ) then
			if CurState == state.Profile then
				MESSAGEMAN:Broadcast("PrevProfile");
				SOUND:PlayOnce(THEME:GetPathS("","CW/S_CMD_MOVE.WAV"));
				return;
			end;
		end;
		if ( params.Name == "HoldDownRight"or params.Name == "HoldRight" ) then
			if CurState == state.Profile then
				MESSAGEMAN:Broadcast("NextProfile");
				SOUND:PlayOnce(THEME:GetPathS("","CW/S_CMD_MOVE.WAV"));
				return;
			end;
		end;
		if ( params.Name == "UpLeft" or params.Name == "Up"  ) then
			if CurState == state.Avatar then
				IsConfirm = false;
				MESSAGEMAN:Broadcast("UpAvatar");
				MESSAGEMAN:Broadcast("DisconfirmAvatar");
				SOUND:PlayOnce(THEME:GetPathS("","CW/S_CMD_MOVE.WAV"));
				return;
			end;
		end;
		if ( params.Name == "UpRight" or params.Name == "Down" ) then
			if CurState == state.Avatar then
				IsConfirm = false;
				MESSAGEMAN:Broadcast("DownAvatar");
				MESSAGEMAN:Broadcast("DisconfirmAvatar");
				SOUND:PlayOnce(THEME:GetPathS("","CW/S_CMD_MOVE.WAV"));
				return;
			end;
		end;
		--MESSAGEMAN:Broadcast(params.Name);
	end;
	
	--[[
	CodeNames="DownLeft,DownRight,Center,Back,HoldDownLeft,HoldDownRight,UpRight,UpLeft"
	CodeBack="Back"
	CodeCenter="Center"
	CodeUpLeft="UpLeft"
	CodeUpRight="UpRight"
	CodeDownLeft="DownLeft"
	CodeDownRight="DownRight"
	CodeHoldDownLeft="+DownLeft"
	CodeHoldDownRight="+DownRight"
	]]--
};

--////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////
local a = Def.ActorFrame {
	InitCommand=cmd(Center);
	StartSelectingAvatarMessageCommand=cmd(stoptweening;decelerate,.2;x,SCREEN_LEFT+90);
	GoBackSelectingProfileMessageCommand=cmd(stoptweening;x,SCREEN_LEFT+90;sleep,.4;decelerate,.2;x,SCREEN_CENTER_X);
};

if not ZeroProfiles then
a[#a+1] = LoadActor( THEME:GetPathG("","ScreenSelectAvatar/scroller back") )..{
	InitCommand=cmd(zoom,.7);
}

a[#a+1] = LoadActor( THEME:GetPathG("","ScreenSelectAvatar/scroller back") )..{
	InitCommand=cmd(zoom,.7;blend,'BlendMode_Add';queuecommand,'Loop');
	LoopCommand=cmd(stoptweening;zoomx,.7;diffusealpha,0;linear,.1;diffusealpha,.5;linear,.5;zoomx,1;diffusealpha,0;queuecommand,'Loop');
	StartSelectingAvatarMessageCommand=cmd(stoptweening;queuecommand,'RushLoop');
	RushLoopCommand=cmd(stoptweening;zoomx,.7;diffusealpha,0;linear,.05;diffusealpha,.5;linear,.2;zoomx,1;diffusealpha,0;queuecommand,'RushLoop');
	GoBackSelectingProfileMessageCommand=cmd(stoptweening;queuecommand,'Loop');
}
end;

if ZeroProfiles then
a[#a+1] = LoadFont("Common Normal")..{
	InitCommand=cmd(settext,'No Profiles to select';strokecolor,0,0,0,1;shadowlength,1);
};
end;

function GetProfilesActors()
	local names = PROFILEMAN:GetLocalProfileDisplayNames();
	local Actors = {};
	for i=1,#names do
		Actors[i] = LoadFont("Common Normal")..{
			InitCommand=cmd(settext,names[i];strokecolor,0,0,0,1;shadowlength,1);--.." - "..tostring(i-1) );
		};
	end;
	return Actors;
end;

-- 0 es el primer item; maaas arriba
--local cur_item = 0;
a[#a+1] = Def.ActorScroller {
	NumItemsToDraw=3;
	SecondsPerItem=0.1;
	InitCommand=function(self)
		self:SetLoop(true);
		self:SetFastCatchup(true);
	--	self:Center();
		self:SetCurrentAndDestinationItem(cur_item);
	end;
	TransformFunction=function(self,offset,itemIndex,numItems)
		local zoom = (4 - offset*offset)/4;
		self:zoom( zoom );
		self:y(offset * 30);
	end;
	PrevProfileMessageCommand=function(self) 
		self:stoptweening();
		local num = self:GetNumItems();
		if ( cur_item == 0 ) then
			self:SetCurrentAndDestinationItem(num);
			cur_item = num;
		end;
		cur_item = cur_item - 1;
		MESSAGEMAN:Broadcast("UpDateAvatar");	-- se tiene que usar ak un mensaje, para obtener una lectura del cur_item actualizado
		self:SetDestinationItem(cur_item);
	end;
	NextProfileMessageCommand=function(self)
		self:stoptweening();
		local num = self:GetNumItems();
		if ( cur_item == num-1 ) then
			self:SetCurrentAndDestinationItem(-1);
			cur_item = -1;
		end;
		cur_item = cur_item + 1;
		MESSAGEMAN:Broadcast("UpDateAvatar");	-- se tiene que usar ak un mensaje, para obtener una lectura del cur_item actualizado
		self:SetDestinationItem(cur_item);
	end;
	children = GetProfilesActors();
};

-- El index en los profiles, empieza por cero
a[#a+1] = LoadFont("Common Normal")..{
	InitCommand=cmd(addy,-80;settext,'Select Profile';strokecolor,0,0,0,1;shadowlength,1);
	--InitCommand=cmd(addy,-80;settext,string.format("%.3d", 30));
	StartSelectingAvatarMessageCommand=cmd(stoptweening;settext,'Select Avatar');
	GoBackSelectingProfileMessageCommand=cmd(stoptweening;settext,'Select Profile');
};

a[#a+1] = Def.Sprite {
	InitCommand=cmd(y,140;Load,nil;zoom,.7;playcommand,'UpDateAvatar');
	UpDateAvatarMessageCommand=function(self)
		local charID = ReadAvatarID( cur_item );
		
		if charID == nil then
			WriteAvatarID( cur_item, 1 );
			charID = 1;
		end;
		
		if (charID > total_avatars) then
			WriteAvatarID( cur_item, 1 );
			charID = 1;
		end;
		
		self:Load( THEME:GetPathG("","_avatars/00000"..string.format("%.3d", (charID) )..".png") );	

	end;
	SimpleUpDateCommand=function(self)
		-- Se supone que al llegar a SelectAvatar, ya se corrigieron los posibles errroes en el SelectProfile
		local charID = ReadAvatarID( cur_item );
		self:Load( THEME:GetPathG("","_avatars/00000"..string.format("%.3d", (charID) )..".png") );
	end;
	ConfirmAvatarMessageCommand=function(self)
		self:Load( THEME:GetPathG("","_avatars/00000"..string.format("%.3d", (item_index) )..".png") );
	end;
	DisconfirmAvatarMessageCommand=cmd(stoptweening;Load,nil;playcommand,'SimpleUpDate');
	GoBackSelectingProfileMessageCommand=cmd(stoptweening;Load,nil;playcommand,'SimpleUpDate');
}

a[#a+1] = Def.Sprite {
	InitCommand=cmd(y,140;Load,nil);
	ConfirmAvatarMessageCommand=function(self)
		self:Load( THEME:GetPathG("","_avatars/00000"..string.format("%.3d", (item_index) )..".png") );
		(cmd(stoptweening;blend,'BlendMode_Add';diffusealpha,1;zoom,.7;decelerate,.4;zoom,.8;diffusealpha,0))(self);
	end;
	DisconfirmAvatarMessageCommand=cmd(stoptweening;Load,nil);
	GoBackSelectingProfileMessageCommand=cmd(stoptweening;Load,nil);
}

if not ZeroProfiles then
a[#a+1] = LoadActor( THEME:GetPathG("","ScreenSelectAvatar/avatar_frame") )..{
	InitCommand=cmd(y,140;zoom,.7;zoomy,.8);
}
end;

a[#a+1] = LoadActor( THEME:GetPathG("","ScreenSelectAvatar/READY") )..{
	InitCommand=cmd(y,195;diffusealpha,0);
	ConfirmAvatarMessageCommand=cmd(stoptweening;diffusealpha,1);
	DisconfirmAvatarMessageCommand=cmd(stoptweening;diffusealpha,0);
	GoBackSelectingProfileMessageCommand=cmd(stoptweening;diffusealpha,0);
}

a[#a+1] = LoadActor( THEME:GetPathG("","ScreenSelectAvatar/READY") )..{
	InitCommand=cmd(y,195;blend,'BlendMode_Add';diffusealpha,0);
	ConfirmAvatarMessageCommand=cmd(stoptweening;diffusealpha,1;diffuseshift;effectcolor2,color("1,1,1,.5");effectcolor1,color("1,1,1,0");effectperiod,.2);
	DisconfirmAvatarMessageCommand=cmd(stoptweening;stopeffect;diffusealpha,0);
	GoBackSelectingProfileMessageCommand=cmd(stoptweening;stopeffect;diffusealpha,0);
}
t[#t+1] = a;
--////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Index para el cursor ; maaas arriba
--local item_index = 1;
--local xul = SCREEN_LEFT+165;
local xul = -275;
--local yul = SCREEN_TOP-15;
local yul = -275;

local x_pos = {};
local y_pos = {};
local pos_matrix = {};

for i=1,8 do
	x_pos[i] = xul + i*55;
end;

for i=1,32 do
	y_pos[i] = yul + i*55;
end;

for i=1,total_avatars do
	local yt = math.ceil( i/8 );
	local xt = i-(8*(yt-1));
	pos_matrix[i] = { x=x_pos[xt] ; y=y_pos[yt] }
end;

-- Primer set de avatares
local y = Def.ActorFrame {
	--InitCommand=cmd(x,SCREEN_RIGHT-220+20;y,SCREEN_TOP+220+40;zoom,0);
	InitCommand=cmd(x,SCREEN_RIGHT+250;y,SCREEN_TOP+220+40);
	StartSelectingAvatarMessageCommand=cmd(stoptweening;sleep,.4;decelerate,.1;x,SCREEN_RIGHT-210;decelerate,.05;x,SCREEN_RIGHT-200);
	--StartSelectingAvatarMessageCommand=cmd(stoptweening;sleep,.4;decelerate,.2;zoom,1.05;decelerate,.05;zoom,1);
	--GoBackSelectingProfileMessageCommand=cmd(stoptweening;zoom,1;decelerate,.1;zoom,1.05;decelerate,.05;zoom,0);
	GoBackSelectingProfileMessageCommand=cmd(stoptweening;decelerate,.1;x,SCREEN_RIGHT-210;decelerate,.05;x,SCREEN_RIGHT+250);
	MovePanelUpMessageCommand=function(self,params)
		if params.panel == 2 then
			(cmd(stoptweening;y,SCREEN_TOP+220+40;decelerate,.2;y,SCREEN_TOP-180))(self);
		elseif params.panel == 3 then
			(cmd(stoptweening;y,SCREEN_TOP-180;decelerate,.2;y,SCREEN_TOP-620))(self);
		elseif params.panel == 4 then
			(cmd(stoptweening;y,SCREEN_TOP-620;decelerate,.2;y,SCREEN_TOP-1060))(self);
		end;
	end;
	MovePanelDownMessageCommand=function(self,params)
		if params.panel == 1 then
			(cmd(stoptweening;y,SCREEN_TOP-180;decelerate,.2;y,SCREEN_TOP+220+40))(self);
		elseif params.panel == 2 then
			(cmd(stoptweening;y,SCREEN_TOP-620;decelerate,.2;y,SCREEN_TOP-180))(self);
		elseif params.panel == 3 then
			(cmd(stoptweening;y,SCREEN_TOP-1060;decelerate,.2;y,SCREEN_TOP-620))(self);
		end;
	end;
};

for i=1,total_avatars do
y[#y+1] = Def.ActorFrame {
	LoadActor( THEME:GetPathG("","_avatars/00000"..string.format("%.3d", (i))..".png") )..{
		InitCommand=cmd(zoom,.4;x,pos_matrix[i].x;y,pos_matrix[i].y;ztestmode,'ZTestMode_WriteOnPass');
		ConfirmAvatarMessageCommand=function(self)
			if i==item_index then return; end;
			(cmd(stoptweening;diffuse,.2,.2,.2,1))(self)
		end;
		DisconfirmAvatarMessageCommand=cmd(stoptweening;diffuse,1,1,1,1);
		GoBackSelectingProfileMessageCommand=cmd(stoptweening;sleep,.15;diffuse,1,1,1,1);
	},
	LoadFont("AvatarsNumber")..{
		InitCommand=cmd(zoomy,.5;zoomx,.3;settext,string.format("%.3d", (i));x,pos_matrix[i].x;y,pos_matrix[i].y-24;ztestmode,'ZTestMode_WriteOnPass');
		ConfirmAvatarMessageCommand=function(self)
			if i==item_index then return; end;
			(cmd(stoptweening;diffuse,.2,.2,.2,1))(self)
		end;
		DisconfirmAvatarMessageCommand=cmd(stoptweening;diffuse,1,1,1,1);
		GoBackSelectingProfileMessageCommand=cmd(stoptweening;sleep,.15;diffuse,1,1,1,1);
	},
};
end;

--////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////
local panel = { First = "First", Second = "Second", Third = "Third", Fourth = "Fourth" };
local cur_panel = panel.First;

-- Cursor 1st set
--local item_index = 1; mas arriba
y[#y+1] = LoadActor( THEME:GetPathG("","ScreenSelectAvatar/avatar_cursor.png") )..{
	InitCommand=cmd(zoom,.4;x,pos_matrix[item_index].x;y,pos_matrix[item_index].y;pulse;effectperiod,1;effectmagnitude,.95,1,1.1);
	ConfirmAvatarMessageCommand=cmd(stoptweening;pulse;effectperiod,.2;effectmagnitude,.9,1,1.1);
	DisconfirmAvatarMessageCommand=cmd(stoptweening;pulse;effectperiod,1;effectmagnitude,.95,1,1.1);
	LeftAvatarMessageCommand=function(self)
		self:effectperiod(1);
		if ( (item_index-1)<65 and cur_panel == panel.Second ) then 
			cur_panel = panel.First;
			MESSAGEMAN:Broadcast("MovePanelDown",{ panel = 1 });
			SOUND:PlayOnce(THEME:GetPathS("","Sounds/M_MOVE.WAV"));
		end;
		if ( (item_index-1)<129 and cur_panel == panel.Third ) then 
			cur_panel = panel.Second;
			MESSAGEMAN:Broadcast("MovePanelDown",{ panel = 2 });
			SOUND:PlayOnce(THEME:GetPathS("","Sounds/M_MOVE.WAV"));
		end;
		if ( (item_index-1)<193 and cur_panel == panel.Fourth ) then 
			cur_panel = panel.Third;
			MESSAGEMAN:Broadcast("MovePanelDown",{ panel = 3 });
			SOUND:PlayOnce(THEME:GetPathS("","Sounds/M_MOVE.WAV"));
		end;
		if ( (item_index-1)<1 ) then return; end;
		item_index = item_index - 1;
		self:x(pos_matrix[item_index].x);
		self:y(pos_matrix[item_index].y);
	end;
	RightAvatarMessageCommand=function(self)
		self:effectperiod(1);
		if ( (item_index+1)>64 and cur_panel == panel.First ) then
			cur_panel = panel.Second;
			MESSAGEMAN:Broadcast("MovePanelUp",{ panel = 2 });
			SOUND:PlayOnce(THEME:GetPathS("","Sounds/M_MOVE.WAV"));
		end;
		if ( (item_index+1)>128 and cur_panel == panel.Second ) then
			cur_panel = panel.Third;
			MESSAGEMAN:Broadcast("MovePanelUp",{ panel = 3 });
			SOUND:PlayOnce(THEME:GetPathS("","Sounds/M_MOVE.WAV"));
		end;
		if ( (item_index+1)>192 and cur_panel == panel.Third ) then
			cur_panel = panel.Fourth;
			MESSAGEMAN:Broadcast("MovePanelUp",{ panel = 4 });
			SOUND:PlayOnce(THEME:GetPathS("","Sounds/M_MOVE.WAV"));
		end;
		if ( (item_index+1)>total_avatars )then return; end;
		item_index = item_index + 1;
		self:x(pos_matrix[item_index].x);
		self:y(pos_matrix[item_index].y);
	end;
	UpAvatarMessageCommand=function(self)
		self:effectperiod(1);
		if ( (item_index-8)<65 and cur_panel == panel.Second ) then 
			cur_panel = panel.First;
			MESSAGEMAN:Broadcast("MovePanelDown",{ panel = 1 });
			SOUND:PlayOnce(THEME:GetPathS("","Sounds/M_MOVE.WAV"));
		end;
		if ( (item_index-8)<129 and cur_panel == panel.Third ) then 
			cur_panel = panel.Second;
			MESSAGEMAN:Broadcast("MovePanelDown",{ panel = 2 });
			SOUND:PlayOnce(THEME:GetPathS("","Sounds/M_MOVE.WAV"));
		end;
		if ( (item_index-8)<193 and cur_panel == panel.Fourth ) then 
			cur_panel = panel.Third;
			MESSAGEMAN:Broadcast("MovePanelDown",{ panel = 3 });
			SOUND:PlayOnce(THEME:GetPathS("","Sounds/M_MOVE.WAV"));
		end;
		if ( (item_index-8)<1 ) then return; end;
		item_index = item_index - 8;
		self:x(pos_matrix[item_index].x);
		self:y(pos_matrix[item_index].y);
	end;
	DownAvatarMessageCommand=function(self)
		self:effectperiod(1);
		if ( (item_index+8)>64 and cur_panel == panel.First )then 
			cur_panel = panel.Second;
			MESSAGEMAN:Broadcast("MovePanelUp",{ panel = 2 });
			SOUND:PlayOnce(THEME:GetPathS("","Sounds/M_MOVE.WAV"));
		end;
		if ( (item_index+8)>128 and cur_panel == panel.Second )then 
			cur_panel = panel.Third;
			MESSAGEMAN:Broadcast("MovePanelUp",{ panel = 3 });
			SOUND:PlayOnce(THEME:GetPathS("","Sounds/M_MOVE.WAV"));
		end;
		if ( (item_index+8)>192 and cur_panel == panel.Third )then 
			cur_panel = panel.Fourth;
			MESSAGEMAN:Broadcast("MovePanelUp",{ panel = 4 });
			SOUND:PlayOnce(THEME:GetPathS("","Sounds/M_MOVE.WAV"));
		end;
		if ( (item_index+8)>total_avatars )then return; end;
		item_index = item_index + 8 ;
		self:x(pos_matrix[item_index].x);
		self:y(pos_matrix[item_index].y);
	end;
	GoBackSelectingProfileMessageCommand=cmd(stoptweening;effectperiod,2);
}

--////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////
t[#t+1] = y;
--t[#t+1] = u;

return t;

-- Code by xMAx