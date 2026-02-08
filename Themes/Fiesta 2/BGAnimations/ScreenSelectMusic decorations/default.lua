local t = Def.ActorFrame {
	OnCommand=cmd(stoptweening;SetDrawByZPosition,true;vanishpoint,SCREEN_CENTER_X,174;fov,60);
};




t[#t+1] = LoadActor( BGDirB.."/SSM_BG" )..{
	InitCommand=cmd(blend,"BlendMode_Add";Center;show_background_properly;loop,true;diffusealpha,0.5);
	OnCommand=cmd(play)
};

t[#t+1] = LoadActor("_nextprev")..{
InitCommand=cmd(draworder,5);

};

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/BGA_SH") )..{
	InitCommand=cmd(diffusealpha,1;draworder,4;zoom,0.67;x,cx;y,cy);
};

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/mw_bg") )..{
	InitCommand=cmd(diffusealpha,1;draworder,4;zoom,0.67;x,cx;y,360);
	OnCommand=cmd(diffusealpha,0;sleep,.25;linear,.25;diffusealpha,.7);
	StartSelectingSongMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,.25;linear,.25;diffusealpha,.7);
	GoBackSelectingGroupMessageCommand=cmd(stoptweening;diffusealpha,.7;linear,.1;diffusealpha,0);

};

t[#t+1] = LoadActor("_songcounter")..{
	InitCommand=cmd(diffusealpha,0;x,cx;y,SCREEN_BOTTOM-112;draworder,7);
	OnCommand=cmd(sleep,0.1;linear,0.1;diffusealpha,1);
	NextSongMessageCommand=cmd(stoptweening;diffusealpha,1;linear,0.15;diffusealpha,0;linear,0.15;diffusealpha,1);
	PreviousSongMessageCommand=cmd(stoptweening;diffusealpha,1;linear,0.15;diffusealpha,0;linear,0.15;diffusealpha,1);
	StartSelectingStepsMessageCommand=cmd(finishtweening;diffusealpha,1;linear,0.1;diffusealpha,0);
	GoBackSelectingSongMessageCommand=cmd(finishtweening;diffusealpha,0;sleep,0.1;linear,0.1;diffusealpha,1);
	GoBackSelectingGroupMessageCommand=cmd(finishtweening;diffusealpha,1;sleep,0.1;linear,0.1;diffusealpha,0);
	StartSelectingSongMessageCommand=cmd(finishtweening;diffusealpha,0;sleep,0.1;linear,0.1;diffusealpha,1);
};

t[#t+1] = LoadActor("_banner_arrows")..{
	InitCommand=cmd(diffusealpha,1;x,cx;y,332;draworder,7);
	
};

t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectMusic/Hex_Left"))..{
		InitCommand=cmd(blend,"BlendMode_Add";zoom,.67;draworder,5;x,SCREEN_CENTER_X-390;y,SCREEN_CENTER_Y;diffusealpha,0.8);
		StartSelectingSongMessageCommand=cmd(visible,true);
		GoBackSelectingGroupMessageCommand=cmd(visible,false);
		NextSongMessageCommand=cmd(finishtweening;diffusealpha,0;sleep,0.8;linear,1;diffusealpha,1;);
		PreviousSongMessageCommand=cmd(finishtweening;diffusealpha,0;sleep,0.8;linear,1;diffusealpha,1;);
	};
	
t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectMusic/Hex_Right"))..{
		InitCommand=cmd(blend,"BlendMode_Add";zoom,.67;draworder,5;x,SCREEN_CENTER_X+390;y,SCREEN_CENTER_Y+24;diffusealpha,0.8);
		StartSelectingSongMessageCommand=cmd(visible,true);
		GoBackSelectingGroupMessageCommand=cmd(visible,false);
		NextSongMessageCommand=cmd(finishtweening;diffusealpha,0;sleep,0.8;linear,1;diffusealpha,1;);
		PreviousSongMessageCommand=cmd(finishtweening;diffusealpha,0;sleep,0.8;linear,1;diffusealpha,1;);
	};

t[#t+1] = LoadActor("_fire")..{
InitCommand=cmd(draworder,5;zoom,.67;x,141;y,65);
};

t[#t+1] = LoadActor("_musicwheel")..{
InitCommand=cmd(draworder,6);
};


-------------------------------------GENERAL------------------------------------------------------
--------------------------------------------------------------------------------------------------
cx = SCREEN_CENTER_X;
cy = SCREEN_CENTER_Y;

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--PREVIEW

t[#t+1] = LoadActor("_preview")..{
	InitCommand=cmd(x,cx;draworder,6);
	OnCommand=cmd(stoptweening;y,145;sleep,.1;linear,.2;y,175);
	StartSelectingSongMessageCommand=cmd(stoptweening;y,145;diffusealpha,0;sleep,.25;linear,.1;y,175;diffusealpha,1);
	GoBackSelectingGroupMessageCommand=cmd(stoptweening;y,175;diffusealpha,1;sleep,.2;linear,.1;y,145;diffusealpha,0);
	OffCommand=cmd(stoptweening;y,175;diffusealpha,1;sleep,.2;linear,.1;y,145;diffusealpha,0);
	TimerOutSelectingSongCommand=cmd(playcommand,'Off');
};

if GAMESTATE:IsSideJoined( PLAYER_1 ) then
	t[#t+1] = GetHighScoresFrameP1( PLAYER_1, false )..{
		InitCommand=cmd(draworder,14;x,cx-232;y,SCREEN_BOTTOM+100;diffusealpha,0);
		StartSelectingStepsMessageCommand=cmd(stoptweening;linear,0.2;y,SCREEN_BOTTOM-78;diffusealpha,1);
		GoBackSelectingSongMessageCommand=cmd(stoptweening;linear,0.2;y,SCREEN_BOTTOM+100;);
	}
	t[#t+1] = LoadFont("SongTitle")..{
		InitCommand=cmd(draworder,16);
		InitiateVisibilityCommand=function(self)
			local stepartist = GAMESTATE:GetCurrentSteps(PLAYER_1):GetAuthorCredit();
			local bytext = "";
			if string.len(stepartist) >= 1 then bytext = "by" end;
			(cmd(draworder,16;settext,bytext;y,SCREEN_BOTTOM-22;zoom,.5;visible,true;x,cx-500;linear,.25;x,cx-124))(self);
		end;
		UpdateVisibilityCommand=function(self)
			local stepartist = GAMESTATE:GetCurrentSteps(PLAYER_1):GetAuthorCredit();
			local bytext = "";
			if string.len(stepartist) >= 1 then bytext = "by" end;
			(cmd(draworder,16;settext,bytext;y,SCREEN_BOTTOM-22;zoom,.5;visible,true;x,cx-124))(self);
		end;
		StartSelectingStepsMessageCommand=cmd(stoptweening;playcommand,'InitiateVisibility');
		ChangeStepsMessageCommand=cmd(stoptweening;playcommand,'UpdateVisibility');
		GoBackSelectingSongMessageCommand=cmd(stoptweening;visible,false);
		OffCommand=cmd(stoptweening;visible,false);
	};
	t[#t+1] = LoadFont("SongTitle")..{
		InitCommand=cmd(draworder,16);
		StartSelectingStepsMessageCommand=cmd(stoptweening;playcommand,'FetchAuthor');
		FetchAuthorCommand=function(self)
			local stepartist = GAMESTATE:GetCurrentSteps(PLAYER_1):GetAuthorCredit();
			if string.len(stepartist) >= 38 then
				stepartist = string.sub(text,1,35);
				stepartist = sterpartist .. "...";
			end;
			self:settext( stepartist );
			self:maxwidth(216);
			(cmd(draworder,16;y,SCREEN_BOTTOM-12;zoom,.5;visible,true;x,cx-500;linear,.25;x,cx-124))(self);
		end;
		UpdateAuthorCommand=function(self)
			local stepartist = GAMESTATE:GetCurrentSteps(PLAYER_1):GetAuthorCredit();
			if string.len(stepartist) >= 38 then
				stepartist = string.sub(text,1,35);
				stepartist = sterpartist .. "...";
			end;
			self:settext( stepartist );
			self:maxwidth(216);
			(cmd(draworder,16;y,SCREEN_BOTTOM-12;zoom,.5;visible,true;x,cx-124))(self);
		end;
		ChangeStepsMessageCommand=cmd(stoptweening;playcommand,'UpdateAuthor');
		GoBackSelectingSongMessageCommand=cmd(stoptweening;visible,false);
		OffCommand=cmd(stoptweening;visible,false);
	};
end;

if GAMESTATE:IsSideJoined( PLAYER_2 ) then
	t[#t+1] = GetHighScoresFrameP2( PLAYER_2, false )..{
		InitCommand=cmd(draworder,14;x,cx+232;y,SCREEN_BOTTOM+100;diffusealpha,0);
		StartSelectingStepsMessageCommand=cmd(stoptweening;linear,0.2;y,SCREEN_BOTTOM-78;diffusealpha,1);
		GoBackSelectingSongMessageCommand=cmd(stoptweening;linear,0.2;y,SCREEN_BOTTOM+100;);
	}
	t[#t+1] = LoadFont("SongTitle")..{
		InitCommand=cmd(draworder,16);
		InitiateVisibilityCommand=function(self)
			local stepartist = GAMESTATE:GetCurrentSteps(PLAYER_2):GetAuthorCredit();
			local bytext = "";
			if string.len(stepartist) >= 1 then bytext = "by" end;
			(cmd(draworder,16;settext,bytext;y,SCREEN_BOTTOM-22;zoom,.5;visible,true;x,cx+500;linear,.25;x,cx+124))(self);
		end;
		UpdateVisibilityCommand=function(self)
			local stepartist = GAMESTATE:GetCurrentSteps(PLAYER_2):GetAuthorCredit();
			local bytext = "";
			if string.len(stepartist) >= 1 then bytext = "by" end;
			(cmd(draworder,16;settext,bytext;y,SCREEN_BOTTOM-22;zoom,.5;visible,true;x,cx+124))(self);
		end;
		StartSelectingStepsMessageCommand=cmd(stoptweening;playcommand,'InitiateVisibility');
		ChangeStepsMessageCommand=cmd(stoptweening;playcommand,'UpdateVisibility');
		GoBackSelectingSongMessageCommand=cmd(stoptweening;visible,false);
		OffCommand=cmd(stoptweening;visible,false);
	};
	t[#t+1] = LoadFont("SongTitle")..{
		InitCommand=cmd(draworder,16);
		StartSelectingStepsMessageCommand=cmd(stoptweening;playcommand,'FetchAuthor');
		FetchAuthorCommand=function(self)
			local stepartist = GAMESTATE:GetCurrentSteps(PLAYER_2):GetAuthorCredit();
			if string.len(stepartist) >= 38 then
				stepartist = string.sub(text,1,35);
				stepartist = sterpartist .. "...";
			end;
			self:settext( stepartist );
			self:maxwidth(216);
			(cmd(draworder,16;y,SCREEN_BOTTOM-12;zoom,.5;visible,true;x,cx+500;linear,.25;x,cx+124))(self);
		end;
		UpdateAuthorCommand=function(self)
			local stepartist = GAMESTATE:GetCurrentSteps(PLAYER_2):GetAuthorCredit();
			if string.len(stepartist) >= 38 then
				stepartist = string.sub(text,1,35);
				stepartist = sterpartist .. "...";
			end;
			self:settext( stepartist );
			self:maxwidth(216);
			(cmd(draworder,16;y,SCREEN_BOTTOM-12;zoom,.5;visible,true;x,cx+124))(self);
		end;
		ChangeStepsMessageCommand=cmd(stoptweening;playcommand,'UpdateAuthor');
		GoBackSelectingSongMessageCommand=cmd(stoptweening;visible,false);
		OffCommand=cmd(stoptweening;visible,false);
	};
end;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--GROUP WHEEL
t[#t+1] = LoadActor("_groupwheel")..{
	OnCommand=cmd(stoptweening;draworder,10;visible,true);
	GoBackSelectingGroupMessageCommand=cmd(stoptweening;visible,true);
	StartSelectingSongMessageCommand=cmd(stoptweening;sleep,.6;queuecommand,'Hide');
	HideCommand=cmd(visible,false);
	TimerOutSelectingSongCommand=cmd(visible,false);
	TimerOutSelectingGroupCommand=cmd(playcommand,'StartSelectingSong');
};

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--FULL MODE THINGS

t[#t+1] = LoadActor("_diff_FM1P.lua")..{
	OnCommand=cmd(draworder,15;stoptweening;x,cx-500;y,386);
	StartSelectingStepsMessageCommand=cmd(stoptweening;playcommand,"ShowUp";x,cx-500;linear,.25;x,cx-124;queuecommand,'HideOffCommand'); 	
	GoBackSelectingSongMessageCommand=cmd(stoptweening;playcommand,"Hide";x,cx-124;sleep,.1;linear,.25;x,cx-500;queuecommand,'HideOnCommand');
	OffCommand=cmd(stoptweening;playcommand,"Hide";x,cx-124;sleep,.1;linear,.25;x,cx-500);
	GoFullModeMessageCommand=cmd(stoptweening;x,cx-124);
	HideOffCommand=cmd(visible,false);
	HideOnCommand=cmd(visible,true);
};

t[#t+1] = LoadActor("_diff_FM2P.lua")..{
	OnCommand=cmd(draworder,15;stoptweening;x,cx+500;y,386);
	StartSelectingStepsMessageCommand=cmd(stoptweening;playcommand,"ShowUp";x,cx+500;linear,.25;x,cx+124;queuecommand,'HideOffCommand'); 	
	GoBackSelectingSongMessageCommand=cmd(stoptweening;playcommand,"Hide";x,cx+124;sleep,.1;linear,.25;x,cx+500;queuecommand,'HideOnCommand');
	OffCommand=cmd(stoptweening;playcommand,"Hide";x,cx+124;sleep,.1;linear,.25;x,cx+500);
	GoFullModeMessageCommand=cmd(stoptweening;x,cx+124);
	HideOffCommand=cmd(visible,false);
	HideOnCommand=cmd(visible,true);
};

t[#t+1] = LoadActor("_diffbar_full")..{
	InitCommand=cmd(draworder,16;x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-58;zoom,.48); --> Quando inicia a cena
	OnCommand=cmd(stoptweening;diffusealpha,0;x,cx-800;linear,.15;x,cx;diffusealpha,1); --> Animação inicial
	StartSelectingSongMessageCommand=cmd(stoptweening;diffusealpha,0;x,cx-800;linear,.15;diffusealpha,1;x,cx); --> Ao voltar do GroupWheel
	GoBackSelectingGroupMessageCommand=cmd(linear,.15;x,cx-800;diffusealpha,0); --> Ao entrar no GroupWheel
	StartSelectingStepsMessageCommand=cmd(diffusealpha,1;y,SCREEN_BOTTOM-58;linear,.2;y,305;zoom,.53); --> Ao selecionar a música
	GoBackSelectingSongMessageCommand=cmd(linear,.2;y,SCREEN_BOTTOM-58;zoom,.48); --> Ao cancelar a seleção da música
	OffCommand=cmd(stoptweening;diffusealpha,1;linear,.5;x,cx-800;diffusealpha,0);
	TimerOutSelectingSongCommand=cmd(stoptweening;diffusealpha,1;sleep,.05;linear,.25;y,305;diffusealpha,0);
};

--SCORE GRADES
t[#t+1] = LoadActor("_grades") .. {
	InitCommand=cmd(draworder,14);
};

--SCORE PLATES
t[#t+1] = LoadActor("_plates") .. {
	InitCommand=cmd(draworder,14);
};

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--PRESS CENTER STEP
t[#t+1] = SimplePlatPiu(cx,cy+80)..{ 
	OnCommand=cmd(visible,false;draworder,100);
	StepsChosenMessageCommand=function(self,params)
		if GAMESTATE:GetNumSidesJoined() == 1 then
			(cmd(stoptweening;visible,true))(self);
		else
			local screen = SCREENMAN:GetTopScreen();
			if screen:IsPlayerReady(PLAYER_1) and screen:IsPlayerReady(PLAYER_2) then
				(cmd(stoptweening;visible,true))(self);
			else
				(cmd(stoptweening;visible,false))(self);
			end;
		end;
		
	end;
	StepsPreselectedCancelledMessageCommand=cmd(stoptweening;visible,false);
	GoBackSelectingSongMessageCommand=cmd(stoptweening;visible,false);
	OffCommand=cmd(stoptweening;visible,false);
};

--------------------------------------------------------------------------------
--ARROWS
t[#t+1] = LoadActor("_arrows")..{
	InitCommand=cmd(draworder,17);
	TimerOutSelectingSongCommand=cmd(playcommand,'Off');
	TimerOutSelectingGroupCommand=cmd(playcommand,'Off');
};

--------------------------------------------------------------------------------------------------
--TIMER

t[#t+1] = LoadActor("_timer")..{
	InitCommand=cmd(draworder,20;y,-40);
	OnCommand=cmd(sleep,.1;linear,.25;y,0);
	OffCommand=cmd(sleep,.1;linear,.25;y,-40);
};


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP+65;diffusealpha,0;zoom,0.35);
	GoBackSelectingGroupMessageCommand=cmd(stoptweening;diffusealpha,0;sleep,.3;linear,.2;diffusealpha,1;sleep,2;linear,.2;diffusealpha,0);
	StartSelectingSongMessageCommand=cmd(stoptweening;linear,.2;diffusealpha,0);
	children = {
		LoadActor(THEME:GetPathG("","Messages/back.png"));
		LoadActor(THEME:GetPathG("","Messages/back_glow.png"))..{
			InitCommand=cmd(blend,"BlendMode_Add");
			OnCommand=cmd(diffusealpha,.8);
		};
		LoadActor(THEME:GetPathG("","Messages/goback_"..GetLanguageText()..".png"))..{
			OnCommand=cmd(zoom,1);
		};
	};
}

t[#t+1] = LoadActor( THEME:GetPathS("","Sounds/ST_BGM (loop)") )..{
	OnCommand=cmd(stop);
	GoBackSelectingGroupMessageCommand=cmd(stoptweening;play);
	StartSelectingSongMessageCommand=cmd(stoptweening;stop);
	PlayerJoinedMessageCommand=cmd(stoptweening;stop);
	OffCommand=cmd(stoptweening;stop);
}

return t
--code by xMAx