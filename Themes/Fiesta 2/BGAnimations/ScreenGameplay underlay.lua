--thanks to StepMod / arka for this, extracted from StepMod 1.2
local function GetStageNumberActor()
	local first_digit;
	local second_digit;
	local stage = STATSMAN:GetStagesPlayed()+1;
	
	if( stage > 99 ) then
		first_digit = 9;
		second_digit = 9;
	else
		first_digit = math.floor(stage/10);
		second_digit = stage - (first_digit*10);
	end;
		
	return Def.ActorFrame {
		LoadActor( THEME:GetPathG("","ScreenGameplay/STAGE_FM") ).. {
			InitCommand=cmd(FromTop,28);
		};
		LoadActor( THEME:GetPathG("","ScreenGameplay/N_FM") ).. {
			InitCommand=cmd(zoom, .5;x,-12;FromTop,34;pause;setstate,first_digit);
		};
		LoadActor( THEME:GetPathG("","ScreenGameplay/N_FM") ).. {
			InitCommand=cmd(zoom, .5;x,12;FromTop,34;pause;setstate,second_digit);
		};
	};
end;



local function PlayerName( Player )
	local t = Def.ActorFrame {
		LoadFont("","_myriad pro 20px") .. {
			Name = "Name";
			InitCommand=cmd(horizalign,left;y,-8;x,-70);
		};
	};
	return t;
end;

local t = Def.ActorFrame {};

local style = GAMESTATE:GetCurrentStyle():GetStyleType();
local pn;
if( GAMESTATE:IsSideJoined(PLAYER_1) ) then pn = PLAYER_1 else pn = PLAYER_2 end;

if( (style=='StyleType_OnePlayerTwoSides') or (style=='StyleType_TwoPlayersSharedSides') ) then
	t[#t+1] = GetStageNumberActor()..{ InitCommand=cmd(basezoom,.67;stoptweening;FromCenterX,-285); };
else
	t[#t+1] = GetStageNumberActor()..{ InitCommand=cmd(basezoom,.67;FromCenterX,0); };
end;


------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
local function GetPlayerPosition( player )
	local P1PosX = SCREEN_CENTER_X-159;
	local P2PosX = SCREEN_CENTER_X+159;
	
	local style = GAMESTATE:GetCurrentSteps(player):GetStepsType();
	
	if IsUnderAttackForPlayer( player ) then
		if style == 'StepsType_Pump_Single' or style == 'StepsType_Pump_Couple' then
			if player == PLAYER_1 then return P1PosX; else return P2PosX; end;
		else
			return SCREEN_CENTER_X;
		end;
	end;
	
	if style == 'StepsType_Pump_Single' or style == 'StepsType_Pump_Couple' then
		if player == PLAYER_1 then return P1PosX; else return P2PosX; end;
	else
		return SCREEN_CENTER_X;
	end;
end;

-- PLAYER 1 --
if GAMESTATE:IsSideJoined(PLAYER_1) then
	local P1PosX = GetPlayerPosition( PLAYER_1 );
	local profile = PROFILEMAN:GetProfile(PLAYER_1);
	local profilename = profile:GetDisplayName();
	if profilename == "" then profilename = "GUEST P1" end;
	
	-- P1 Mods Display --
	local P1mods = GAMESTATE:GetPlayerState(PLAYER_1):GetPlayerOptionsString('ModsLevel_Preferred');
	local P1speedstring = string.sub(P1mods,1,6);
	local P1speed = "1x"
	local P1speedstart, P1speedend = 1,2;
	local P1judge = ", NJ"
	if string.find(P1mods, " Easy") then
		P1judge = ", EJ"
	elseif string.find(P1mods, " Normal") then
		P1judge = ", NJ"
	elseif string.find(P1mods, " Hard") then
		P1judge = ", HJ"
	elseif string.find(P1mods, " VeryHard") then
		P1judge = ", VJ"
	elseif string.find(P1mods, " ExtraHard") then
		P1judge = ", XJ"
	elseif string.find(P1mods, " UltraHard") then
		P1judge = ", UJ"
	end;
	if string.find(P1speedstring, "^%d.*x,") then
		P1speedstart, P1speedend = string.find(P1speedstring, "^%d.*x,");
		P1speed = string.sub(P1speedstring, P1speedstart,P1speedend-1);
	elseif string.find(P1speedstring, "^m%d%d%d,") then
		P1speedstart, P1speedend = string.find(P1speedstring, "^m%d%d%d,");
		P1speed = "AV"..string.sub(P1speedstring, P1speedstart+1,P1speedend-1);
	end;
	P1mods = P1speed..P1judge

	--P1 Avatar--
	t[#t+1] = Def.Sprite {
		Name = "Avatar";
		Texture = THEME:GetPathG("","_avatars/PlayerNumber_P1.png");
		InitCommand=function(self)
			if profilename ~= "GUEST P1" then
				if FILEMAN:GetFileSizeBytes(PROFILEMAN:GetProfileDir("ProfileSlot_Player1").."/avatar.png") > 316 then
					self:Load(PROFILEMAN:GetProfileDir("ProfileSlot_Player1").."/avatar.png");
				else
					local ProfileID = string.sub(PROFILEMAN:GetProfileDir("ProfileSlot_Player1"),-9,-2)
					self:Load(THEME:GetPathG("","_avatars/"..ProfileID..".png"));
				end;
			end;
			self:horizalign(left);
			self:x(SCREEN_LEFT+4);
			self:y(SCREEN_BOTTOM-18);
			self:SetWidth(21);
			self:SetHeight(21);
		end;
	};

	--P1 Score Frame--
	local PersonalBest = 0;
	local cur_song = GAMESTATE:GetCurrentSong();
	local cur_steps = GAMESTATE:GetCurrentSteps(PLAYER_1);
	local HSList = PROFILEMAN:GetProfile(PLAYER_1):GetHighScoreList(cur_song,cur_steps):GetHighScores();
	if HSList ~= nil and #HSList ~= 0 then
		PersonalBest = math.floor(HSList[1]:GetScore()/100);
		if PersonalBest > 2000000 then 
			PersonalBest = 0;
		elseif PersonalBest > 1000000 then 
			PersonalBest = PersonalBest - 1000000;
		end;
	end;
	
	t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSystemLayer/PlayerName background empty") )..{
		InitCommand=cmd(horizalign,left;x,SCREEN_LEFT;y,SCREEN_BOTTOM-18;basezoom,.54);
	};

	t[#t+1] = LoadFont("","_myriad pro 20px") .. {
		InitCommand=cmd(settext,string.upper(string.sub(profilename,1,8));horizalign,left;zoom,.51;maxwidth,82;x,SCREEN_LEFT+28;y,SCREEN_BOTTOM-23);
	};
	
	local maxcomboP1 = 0; 
	local pscoreP1 = 0;
	t[#t+1] = LoadFont("_karnivore lite white") .. {
		InitCommand=cmd(settext,"00.00%";horizalign,right;zoom,.62;x,SCREEN_LEFT+128;y,SCREEN_BOTTOM-16,maxwidth,85);
		JudgmentMessageCommand=function(self,param)
			self:sleep(0.1);
			self:queuecommand('PostLifeChange');
		end;
		PostLifeChangeMessageCommand=function(self)
			local curstats = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1);
			local perfects = curstats:GetTapNoteScores('TapNoteScore_W2') + curstats:GetTapNoteScores('TapNoteScore_CheckpointHit');
			local greats = curstats:GetTapNoteScores('TapNoteScore_W3');
			local goods = curstats:GetTapNoteScores('TapNoteScore_W4');
			local bads = curstats:GetTapNoteScores('TapNoteScore_W5');
			local misses = curstats:GetTapNoteScores('TapNoteScore_Miss') + curstats:GetTapNoteScores('TapNoteScore_CheckpointMiss');
			local currentcombo = curstats:GetCurrentCombo();
			if currentcombo > maxcomboP1 then maxcomboP1 = currentcombo end;
			local stagebreak = curstats:GetReachedLifeZero();
			pscoreP1 = CalcPScore(perfects, greats, goods, bads, misses, maxcomboP1);
			local grade_bonus = 300000;
			if misses > 0 then
				grade_bonus = 0
			elseif bads > 0 or goods > 0 then
				grade_bonus = 100000
			elseif greats > 0 then
				grade_bonus = 150000
			end;
			local pass_bonus = 0;
			if not stagebreak then pass_bonus = 1000000 end;
			local proc_score = ( (pscoreP1 + pass_bonus) * 100 ) - grade_bonus;
			if P1judge == ", VJ" or P1judge == ", XJ" or P1judge == ", UJ" then proc_score = proc_score/1.2 end;
			curstats:SetScore(proc_score);
			local formatted_pscoreP1 = ScoreToPercent(pscoreP1);
			if pscoreP1 > PersonalBest then
				self:diffusecolor(color("#00FFFF"))
			else
				self:diffusecolor(1,1,1,1)
			end;
			self:settext(formatted_pscoreP1);
		end;
		};
		t[#t+1] = LoadActor( THEME:GetPathG("","ScreenGameplay/new_record") )..{
			InitCommand=cmd(horizalign,right;zoom,.22;x,SCREEN_LEFT+80;y,SCREEN_BOTTOM-15,maxwidth,85;visible,false);
			JudgmentMessageCommand=function(self,param)
				self:sleep(0.1);
				self:queuecommand('PostLifeChange');
			end;
			PostLifeChangeMessageCommand=function(self)
				if pscoreP1 >= 1000000 then self:x(SCREEN_LEFT+80) else self:x(SCREEN_LEFT+85) end;
				if pscoreP1 > PersonalBest then
					self:visible(true)
					self:glowshift()
				else
					self:visible(false)
				end;
		end;
	};

	t[#t+1] = LoadFont("","_myriad pro 20px") .. {
		InitCommand=cmd(settext,P1mods;horizalign,left;zoom,.32;x,SCREEN_LEFT+28;y,SCREEN_BOTTOM-15;diffuse,color("#00FFFF"));
	};	

	--P1 Difficulty Ball--
	t[#t+1] = GetSimpleBallLevel( PLAYER_1 )..{ 
		InitCommand=cmd(horizalign,right;basezoom,.18;x,SCREEN_LEFT+145;playcommand,"ShowUp";y,SCREEN_BOTTOM-18);
	};

end;


--PLAYER 2--
if GAMESTATE:IsSideJoined(PLAYER_2) then
	local P2PosX = GetPlayerPosition( PLAYER_2 );
	local profile = PROFILEMAN:GetProfile(PLAYER_2);
	local profilename = profile:GetDisplayName();
	if profilename == "" then profilename = "GUEST P2" end;

	-- P2 Mods Display --
		
	local P2mods = GAMESTATE:GetPlayerState(PLAYER_2):GetPlayerOptionsString('ModsLevel_Preferred');
	local P2speedstring = string.sub(P2mods,1,6);
	local P2speed = "1x"
	local P2speedstart, P2speedend = 1,2;
	local P2judge = ", NJ"
	if string.find(P2mods, " Easy") then
		P2judge = ", EJ"
	elseif string.find(P2mods, " Normal") then
		P2judge = ", NJ"
	elseif string.find(P2mods, " Hard") then
		P2judge = ", HJ"
	elseif string.find(P2mods, " VeryHard") then
		P2judge = ", VJ"
	elseif string.find(P2mods, " ExtraHard") then
		P2judge = ", XJ"
	elseif string.find(P2mods, " UltraHard") then
		P2judge = ", UJ"
	end;
	if string.find(P2speedstring, "^%d.*x,") then
		P2speedstart, P2speedend = string.find(P2speedstring, "^%d.*x,");
		P2speed = string.sub(P2speedstring, P2speedstart,P2speedend-1);
	elseif string.find(P2speedstring, "^m%d%d%d,") then
		P2speedstart, P2speedend = string.find(P2speedstring, "^m%d%d%d,");
		P2speed = "AV"..string.sub(P2speedstring, P2speedstart+1,P2speedend-1);
	end;
	P2mods = P2speed..P2judge

	-- P2 Avatar--
	t[#t+1] = Def.Sprite {
		Name = "Avatar";
		Texture = THEME:GetPathG("","_avatars/PlayerNumber_P2.png");
		InitCommand=function(self)
			if profilename ~= "GUEST P2" then
				if FILEMAN:GetFileSizeBytes(PROFILEMAN:GetProfileDir("ProfileSlot_Player2").."/avatar.png") > 316 then
					self:Load(PROFILEMAN:GetProfileDir("ProfileSlot_Player2").."/avatar.png");
				else
					local ProfileID = string.sub(PROFILEMAN:GetProfileDir("ProfileSlot_Player2"),-9,-2)
					self:Load(THEME:GetPathG("","_avatars/"..ProfileID..".png"));
				end;
			end;
			self:horizalign(right);
			self:basezoom(.54);
			self:SetWidth(38);
			self:SetHeight(38);
			self:x(SCREEN_RIGHT-108);
			self:y(SCREEN_BOTTOM-18);
		end;
	};

	--P2 Score Frame--
	local PersonalBest = 0;
	local cur_song = GAMESTATE:GetCurrentSong();
	local cur_steps = GAMESTATE:GetCurrentSteps(PLAYER_2);
	local HSList = PROFILEMAN:GetProfile(PLAYER_2):GetHighScoreList(cur_song,cur_steps):GetHighScores();
	if HSList ~= nil and #HSList ~= 0 then
		PersonalBest = math.floor(HSList[1]:GetScore()/100);
		if PersonalBest > 2000000 then 
			PersonalBest = 0;
		elseif PersonalBest > 1000000 then 
			PersonalBest = PersonalBest - 1000000;
		end;
	end;
	t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSystemLayer/PlayerName background empty") )..{
		InitCommand=cmd(horizalign,right;x,SCREEN_RIGHT;y,SCREEN_BOTTOM-18;basezoom,.54);
	};

	t[#t+1] = LoadFont("","_myriad pro 20px") .. {
		InitCommand=cmd(settext,string.upper(string.sub(profilename,1,8));horizalign,left;zoom,.51;x,SCREEN_RIGHT-105;y,SCREEN_BOTTOM-23);
	};

	--P2 Real Time Score--
	
	local maxcomboP2 = 0;
	local pscoreP2 = 0;
	t[#t+1] = LoadFont("_karnivore lite white") .. {
		InitCommand=cmd(settext,"00.00%";horizalign,right;zoom,.62;x,SCREEN_RIGHT-5;y,SCREEN_BOTTOM-16;maxwidth,85);
		JudgmentMessageCommand=function(self,param)
			self:sleep(0.1);
			self:queuecommand('PostLifeChange');
		end;
		PostLifeChangeMessageCommand=function(self)
			local curstats = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2);
			local perfects = curstats:GetTapNoteScores('TapNoteScore_W2') + curstats:GetTapNoteScores('TapNoteScore_CheckpointHit');
			local greats = curstats:GetTapNoteScores('TapNoteScore_W3');
			local goods = curstats:GetTapNoteScores('TapNoteScore_W4');
			local bads = curstats:GetTapNoteScores('TapNoteScore_W5');
			local misses = curstats:GetTapNoteScores('TapNoteScore_Miss') + curstats:GetTapNoteScores('TapNoteScore_CheckpointMiss');
			local currentcombo = curstats:GetCurrentCombo();
			if currentcombo > maxcomboP2 then maxcomboP2 = currentcombo end;
			local stagebreak = curstats:GetReachedLifeZero();
			pscoreP2 = CalcPScore(perfects,greats,goods,bads,misses,maxcomboP2);
			local grade_bonus = 300000;
			if misses > 0 then
				grade_bonus = 0
			elseif bads > 0 or goods > 0 then
				grade_bonus = 100000
			elseif greats > 0 then
				grade_bonus = 150000
			end;
			local pass_bonus = 0;
			if not stagebreak then pass_bonus = 1000000 end;
			local proc_score = ( (pscoreP2 + pass_bonus) * 100 ) - grade_bonus;
			if P2judge == ", VJ" or P2judge == ", XJ" or P2judge == ", UJ" then proc_score = proc_score/1.2 end;
			curstats:SetScore(proc_score);
			local formatted_pscoreP2 = ScoreToPercent(pscoreP2);
			if pscoreP2 > PersonalBest then
				self:diffusecolor(color("#00FFFF"))
			else
				self:diffusecolor(1,1,1,1)
			end;
			self:settext(formatted_pscoreP2);
		end;
	};

	t[#t+1] = LoadFont("","_myriad pro 20px") .. {
		InitCommand=cmd(settext,P2mods;horizalign,left;zoom,.32;x,SCREEN_RIGHT-105;y,SCREEN_BOTTOM-15;diffuse,color("#00FFFF"));
		};
		t[#t+1] = LoadActor( THEME:GetPathG("","ScreenGameplay/new_record") )..{
			InitCommand=cmd(horizalign,right;zoom,.22;x,SCREEN_RIGHT-53;y,SCREEN_BOTTOM-15,maxwidth,85;visible,false);
			JudgmentMessageCommand=function(self,param)
				self:sleep(0.1);
				self:queuecommand('PostLifeChange');
			end;
			PostLifeChangeMessageCommand=function(self)
				if pscoreP2 >= 1000000 then self:x(SCREEN_RIGHT-53) else self:x(SCREEN_RIGHT-48) end;
				if pscoreP2 > PersonalBest then
					self:visible(true)
					self:glowshift()
				else
					self:visible(false)
				end;
			end;
		};	


	-- P2 Difficulty Ball --

	t[#t+1] = GetSimpleBallLevel( PLAYER_2 )..{ 
		InitCommand=cmd(horizalign,right;basezoom,.18;x,SCREEN_RIGHT-144;playcommand,"ShowUp";y,SCREEN_BOTTOM-18);
	};

end;

-- Song Title --

local songtitle = GAMESTATE:GetCurrentSong():GetDisplayMainTitle();
local cur_song = GAMESTATE:GetCurrentSong();
local cur_steps = GAMESTATE:GetCurrentSteps(PLAYER_1);
songtitle = string.upper(songtitle);

t[#t+1] = Def.BitmapText {
	Font="_myriad pro 20px",
	Text="♫"..songtitle,
	InitCommand=function(self)
		self:y(SCREEN_BOTTOM-9);
		self:x(SCREEN_CENTER_X);
		self:zoom(.84);
		self:maxwidth(440);
		self:diffuse(color("#ccfffe"));
	end;
};

return t;