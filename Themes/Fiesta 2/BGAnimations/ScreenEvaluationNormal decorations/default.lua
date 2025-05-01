local MachineText = "Phyrebird"

local t = Def.ActorFrame {
	GoNextScreenMessageCommand=cmd(playcommand,'Off');
};

local init_pos = 150;
local delta = 19;
local init_sleep = 0.05;
local spacing = 1.8;
local zoom_judges = .70

t[#t+1] = Def.Quad {
	InitCommand=cmd(Center;scaletoclipped,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,.7);
};

-- Blue bars
t[#t+1] = LoadActor( THEME:GetPathG("","ScreenEvaluation/_perfect.png") )..{
	InitCommand=cmd(basezoom,zoom_judges;);
	OnCommand=cmd(x,SCREEN_RIGHT;y,init_pos+delta*3;rotationx,90;sleep,0;linear,.25;x,SCREEN_CENTER_X;rotationx,0);
	OffCommand=cmd(finishtweening;linear,.25;rotationx,90);
};

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenEvaluation/_great.png") )..{
	InitCommand=cmd(basezoom,zoom_judges);
	OnCommand=cmd(x,SCREEN_LEFT;y,spacing*1+init_pos+delta*4;rotationx,90;sleep,init_sleep*1;linear,.25;x,SCREEN_CENTER_X;rotationx,0);
	OffCommand=cmd(finishtweening;linear,.25;rotationx,90);
};

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenEvaluation/_good.png") )..{
	InitCommand=cmd(basezoom,zoom_judges);
	OnCommand=cmd(x,SCREEN_RIGHT;y,spacing*2+init_pos+delta*5;rotationx,90;sleep,init_sleep*2;linear,.25;x,SCREEN_CENTER_X;rotationx,0);
	OffCommand=cmd(finishtweening;linear,.25;rotationx,90);
};

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenEvaluation/_bad.png") )..{
	InitCommand=cmd(basezoom,zoom_judges);
	OnCommand=cmd(x,SCREEN_LEFT;y,spacing*3+init_pos+delta*6;rotationx,90;sleep,init_sleep*3;linear,.25;x,SCREEN_CENTER_X;rotationx,0);
	OffCommand=cmd(finishtweening;linear,.25;rotationx,90);
};

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenEvaluation/_miss.png") )..{
	InitCommand=cmd(basezoom,zoom_judges);
	OnCommand=cmd(x,SCREEN_RIGHT;y,spacing*4+init_pos+delta*7;rotationx,90;sleep,init_sleep*4;linear,.25;x,SCREEN_CENTER_X;rotationx,0);
	OffCommand=cmd(finishtweening;linear,.25;rotationx,90);
};

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenEvaluation/_maxcombo.png") )..{
	InitCommand=cmd(basezoom,zoom_judges);
	OnCommand=cmd(x,SCREEN_LEFT;y,spacing*5+init_pos+delta*8;rotationx,90;sleep,init_sleep*5;linear,.25;x,SCREEN_CENTER_X;rotationx,0);
	OffCommand=cmd(finishtweening;linear,.25;rotationx,90);
};

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenEvaluation/_cal.png") )..{
	InitCommand=cmd(basezoom,zoom_judges);
	OnCommand=cmd(x,SCREEN_RIGHT;y,spacing*6+init_pos+delta*9;rotationx,90;sleep,init_sleep*7;linear,.25;x,SCREEN_CENTER_X;rotationx,0);
	OffCommand=cmd(finishtweening;linear,.25;rotationx,90);
};

-- Score Title and Score BG (Black Retangle)

--p1
if GAMESTATE:IsSideJoined( PLAYER_1 ) then
t[#t+1] = LoadActor( THEME:GetPathG("","ScreenEvaluation/_score_bg.png") )..{
	InitCommand=cmd(basezoom,.40; diffusealpha,0);
	OnCommand=cmd(zoomx,-1;x,SCREEN_CENTER_X-275;y,init_pos+delta*2;sleep,3.1;linear,.25;diffusealpha,1);
	OffCommand=cmd(finishtweening;linear,.25;rotationx,90);
};

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenEvaluation/_total.png") )..{
	InitCommand=cmd(basezoom,.69; diffusealpha,0);
	OnCommand=cmd(x,SCREEN_CENTER_X-280;y,init_pos+3;sleep,3.1;linear,.25;diffusealpha,1);
	OffCommand=cmd(finishtweening;linear,.25;rotationx,90);
};
end;

--p2
if GAMESTATE:IsSideJoined( PLAYER_2 ) then
t[#t+1] = LoadActor( THEME:GetPathG("","ScreenEvaluation/_score_bg.png") )..{
	InitCommand=cmd(basezoom,.40; diffusealpha,0);
	OnCommand=cmd(x,SCREEN_CENTER_X+275;y,init_pos+delta*2;sleep,3.1;linear,.25;diffusealpha,1);
	OffCommand=cmd(finishtweening;linear,.25;rotationx,90);
};


t[#t+1] = LoadActor( THEME:GetPathG("","ScreenEvaluation/_total.png") )..{
	InitCommand=cmd(basezoom,.69; diffusealpha,0);
	OnCommand=cmd(x,SCREEN_CENTER_X+280;y,init_pos+3;sleep,3.1;linear,.25;diffusealpha,1);
	OffCommand=cmd(finishtweening;linear,.25;rotationx,90);
};
end;


-- Grades
t[#t+1] = LoadActor( "_grades.lua" )..{
	GoNextScreenMessageCommand=cmd(visible,false);
	OffCommand=cmd(stoptweening;visible,false);
}

t[#t+1] = LoadActor( "_scores.lua" )..{
	GoNextScreenMessageCommand=cmd(visible,false);
	OffCommand=cmd(stoptweening;visible,false);
}

-- BG and Machine Name

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenEvaluation/_shadoww.png") )..{
	InitCommand=cmd(zoomx,.35; zoomy, .70);
	OnCommand=cmd( x,SCREEN_RIGHT-120;y,SCREEN_BOTTOM-20;rotationx,90;sleep,0;linear,.25;rotationx,0);
	OffCommand=cmd(finishtweening;y,66;linear,.4;y,-28);
};

t[#t+1] = LoadFont("_myriad pro 20px")..{
	InitCommand=cmd(x,-9000000000000);
	OnCommand=cmd(visible, true; sleep,1;x,SCREEN_RIGHT-115;y,SCREEN_BOTTOM-20;linear,0;zoom,.65;shadowlength,1;diffuse,1,1,1,1;settext,MachineText);
	OffCommand=cmd(stoptweening;visible,false);
}

-- BG and Song Title

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenEvaluation/_shadow.png") )..{
	InitCommand=cmd(zoomx,.70; zoomy, 1.40);
	OnCommand=cmd(x,SCREEN_CENTER_X;y,89;rotationx,90;sleep,0;linear,.25;rotationx,0);
	OffCommand=cmd(finishtweening;y,66;linear,.4;y,-28);
};

t[#t+1] = LoadFont("_myriad pro 20px")..{
	OnCommand=cmd(y,-66;sleep,1;linear,0;y,SCREEN_TOP+90;x,SCREEN_CENTER_X;shadowlength,0;diffuse,1,1,1,1;settext,GAMESTATE:GetCurrentSong():GetDisplayMainTitle());
	OffCommand=cmd(stoptweening;visible,false);
}

-- Funções para o +NewScore 
function NewScore( x, y, score, horizalign, delay )
    return LoadFont("_myriad pro 20px")..{
        OnCommand = function(self)
            self:x(x);
            self:y(y);
            self:horizalign(horizalign);
            self:sleep(delay);
            self:settext(AddDots(score)); -- Exibe diretamente o valor final com '+'
        end;
        OffCommand = cmd(stoptweening; visible, false);
    }
end;

function AddCommas(number)
    -- Converte o número para string
    local str = tostring(number)
    -- Adiciona vírgulas como separadores de milhares
    local formatted = str:reverse():gsub("(%d%d%d)", "%1,"):reverse()
    -- Remove vírgula extra, se houver
    if formatted:sub(1, 1) == "," then
        formatted = formatted:sub(2)
    end
    return formatted
end

function DrawRollingNumberSmall( x, y, score_init, score, horizalign, delay )
local score_in = string.format("%6d",score_init);
local score_s = string.format("%6d",score);
local digits = {};
local digitss = {};
local len = string.len(score_s);
local len_in = string.len(score_in);

for i=1,len do
	digits[#digits+1]=string.sub(score_s,i,i);
end;
for i=1,len_in do
	digitss[#digitss+1]=string.sub(score_in,i,i);
end;

local cur_text = "";
local cur_text_digits = "";
local cur_digit = 1;
local cur_loop_digit = 0;
local score_scroller = score_init;

return LoadFont("_karnivore lite white 20px")..{
	OnCommand=function(self)
		self:x(x);
		self:y(y);
		self:horizalign(horizalign);
		self:sleep(delay);
		self:settext(AddDots(score_init));
		if score_init < score then
			self:queuecommand('Update2');
		end;
	end;
	Update2Command=function(self)
		if score_scroller >= score then
			return;
		end;
		local delta = 100000000;
		while (score_scroller + delta) > score do
			delta = delta / 10;
		end;
		score_scroller = score_scroller + delta;
		self:settext(AddDots(score_scroller));
		self:sleep(.04);
		self:queuecommand('Update2');
	end;
	UpdateCommand=function(self)
		if( cur_loop_digit == 5 ) then
			cur_loop_digit = 0;
			cur_text_digits = cur_text_digits..digits[cur_digit];
			if cur_digit ~= len_in and math.mod(cur_digit,3)==0 then
				 cur_text_digits = cur_text_digits..".";
			end;
			
			cur_digit = cur_digit + 1;
			
			if( cur_digit > #digits ) then
				self:settext(cur_text_digits);
				return;
			end;
		end;
		
		cur_text = cur_text_digits..tostring(cur_loop_digit*2+1);
		if math.mod(cur_digit,3)==0 and cur_digit ~= len then
			 cur_text = cur_text..".";
		end;
		if cur_digit < len then
			for i=cur_digit+1,len_in do
				cur_text = cur_text..digitss[i];
				if i ~= len_in and math.mod(i,3)==0 then
					 cur_text = cur_text..".";
				end;
			end;
		end;
		self:settext(cur_text);
		cur_loop_digit = cur_loop_digit +1;
		
		self:sleep(.04);
		self:queuecommand('Update');
	end;
	OffCommand=cmd(stoptweening;visible,false);
}
end;

--Total Score High Score Frame--
function GetHighScoresFrameEval( pn )
local a = Def.ActorFrame {};
	
a[#a+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/highscores_bg") )..{
	InitCommand=cmd(basezoom,.66;zoomx,0;);
	OnCommand=cmd(stoptweening;zoomx,0;linear,.2;zoomx,1);
	OffCommand=cmd(stoptweening;zoomx,1;linear,.2;zoomx,0);
};
		
local cur_song = GAMESTATE:GetCurrentSong();
local cur_steps = GAMESTATE:GetCurrentSteps( pn );

if GAMESTATE:HasProfile( pn ) then
	local HSList = PROFILEMAN:GetProfile( pn ):GetHighScoreList(cur_song,cur_steps):GetHighScores();
	local CurrentHighScore = 0;
	local LastHighScore = 0;
	if HSList ~= nil and #HSList ~= 0 then
		local OldHS = 0;
		local NewHS = math.floor(HSList[1]:GetScore()/100);
		CurrentHighScore = HSList[1]:GetScore()
		if NewHS > 2000000 then 
			NewHS = 0;
		elseif NewHS > 1000000 then 
			NewHS = NewHS - 1000000;
		end;
		if #HSList > 1 then
			OldHS = math.floor(HSList[2]:GetScore()/100);
			LastHighScore = HSList[2]:GetScore()
			if OldHS > 2000000 then 
				OldHS = 0;
			elseif OldHS > 1000000 then 
				OldHS = OldHS - 1000000;
			end;
		end;
		--personal hs
		a[#a+1] = DrawRollingNumberSmall(-40,-14,OldHS,NewHS,left,.6)..{
			InitCommand=cmd(zoom,.62;maxwidth,85;diffusealpha,0;sleep,.5;diffusealpha,1);
			OnCommand=function(self)
				if not SCREENMAN:GetTopScreen():PlayerHasNewRecord(pn) then
					self:visible(false);
				end;
			end;
			OffCommand=cmd(stoptweening;visible,false);
		};

		a[#a+1] = NewScore(85,SCREEN_TOP-202,NewHS-OldHS,right,4)..{
			InitCommand=cmd(zoom,.62;maxwidth,85;diffusealpha,0;sleep,3.3;diffusealpha,1);
			OnCommand=function(self)
				self:settext("+ " .. AddCommas(NewHS-OldHS) )
				if not SCREENMAN:GetTopScreen():PlayerHasNewRecord(pn) then
					self:visible(false);
				end;
				if (NewHS-OldHS) < 1 then
					self:visible(false);
				end;
			end;
			OffCommand=cmd(stoptweening;visible,false);
		};

		a[#a+1] = DrawRollingNumberSmall(-40,-14,NewHS,NewHS,left,4)..{
			InitCommand=cmd(zoom,.62;maxwidth,85;diffusealpha,0;sleep,.5;diffusealpha,1);
			OnCommand=function(self)
				if SCREENMAN:GetTopScreen():PlayerHasNewRecord(pn) then
					self:visible(false);
					local processed_meter = GAMESTATE:GetCurrentSteps(pn):GetMeter();
					if processed_meter == 99 and string.find(cur_steps:GetDescription(),"DP COOP") then processed_meter = 29 elseif processed_meter == 99 then processed_meter = 15 elseif processed_meter > 28 then processed_meter = 28 elseif processed_meter < 1 then processed_meter = 1 end;
					local exp_divisor = 1;
					local chartstyle = cur_steps:GetChartStyle();
					if not string.find(chartstyle,"ACTIVE") then exp_divisor = 5 end;
					local Total_EXP = PROFILEMAN:GetProfile( pn ):GetVoomax();
					Total_EXP = Total_EXP - math.round(CalcEXP(processed_meter,LastHighScore)/exp_divisor) + math.round(CalcEXP(processed_meter,CurrentHighScore)/exp_divisor);
					PROFILEMAN:GetProfile( pn ):SetVoomax(Total_EXP);
					PROFILEMAN:SaveProfile(pn);
				end;
			end;
			OffCommand=cmd(stoptweening;visible,false);
		};
	end;
end;

local HSListMachine = PROFILEMAN:GetMachineProfile():GetHighScoreList(cur_song,cur_steps):GetHighScores();
if HSListMachine ~= nil and #HSListMachine ~= 0 then
	--machine best name
	a[#a+1] = LoadFont("","_myriad pro 20px") .. {
		InitCommand=cmd(settext,"";horizalign,left;zoom,.62;x,-40;y,12);
		RefreshTextCommand=function(self)
			self:settext( string.upper( HSListMachine[1]:GetName() ));
		end;
		OnCommand=cmd(stoptweening;settext,"";sleep,.5;queuecommand,'RefreshText');
		OffCommand=cmd(stoptweening;visible,false);
	};

	--machine best hs
	local OldHS = 0;
	local NewHS = math.floor(HSListMachine[1]:GetScore()/100);
	if NewHS > 2000000 then
		NewHS = 0;
	elseif NewHS > 1000000 then 
		NewHS = NewHS - 1000000;
	end;
	if #HSListMachine > 1 then
		OldHS = math.floor(HSListMachine[2]:GetScore()/100);
		if OldHS > 2000000 then 
			OldHS = 0;
		elseif OldHS > 1000000 then 
			OldHS = OldHS - 1000000;
		end;
	end;
	a[#a+1] = DrawRollingNumberSmall(-40,21,OldHS,NewHS,left,.6)..{
		InitCommand=cmd(zoom,.62;maxwidth,85;diffusealpha,0;sleep,.5;diffusealpha,1);
		OnCommand=function(self)
			if not SCREENMAN:GetTopScreen():PlayerHasNewMachineRecord(pn) then
				self:visible(false);
			end;
		end;
		OffCommand=cmd(stoptweening;visible,false);
	};
	a[#a+1] = DrawRollingNumberSmall(-40,21,NewHS,NewHS,left,.6)..{
		InitCommand=cmd(zoom,.62;maxwidth,85;diffusealpha,0;sleep,.5;diffusealpha,1);
		OnCommand=function(self)
			if SCREENMAN:GetTopScreen():PlayerHasNewMachineRecord(pn) then
				self:visible(false);
			end;
		end;
		OffCommand=cmd(stoptweening;visible,false);
	};
	
	
end;

a[#a+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/highscores_glow") )..{
	InitCommand=cmd(basezoom,.66;diffuse,0,1,1,1;blend,'BlendMode_Add');
	OnCommand=cmd(stoptweening;horizalign,center;diffusealpha,0;zoomx,0;x,0;sleep,.2;linear,.1;zoomx,1;diffusealpha,.8;linear,.1;zoomx,0;diffusealpha,0;queuecommand,'Loop');
	LoopCommand=cmd(stoptweening;zoomx,1;diffusealpha,0;linear,1;diffusealpha,.1;linear,1;diffusealpha,0;queuecommand,'Loop');
	OffCommand=cmd(stoptweening;zoomx,0;x,0);
};

return a;
end;


-- P.Score High Score Frame --

function GetPHighScoresFrameEval( pn )
	local a = Def.ActorFrame {};
		
	a[#a+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/highscores_bg") )..{
		InitCommand=cmd(basezoom,.66;zoomx,0);
		OnCommand=cmd(stoptweening;zoomx,0;linear,.2;zoomx,1);
		OffCommand=cmd(stoptweening;zoomx,1;linear,.2;zoomx,0);
	};
	
	local PersonalBestIndex = 1; 
	local PersonalBestPScore = 0;
	local MachineBestIndex = 1;
	local MachineBestPScore = 0;
	local MachineBestName = "";
	local prev_PersonalBestIndex = 1; 
	local prev_PersonalBestPScore = 0;
	local prev_MachineBestIndex = 1;
	local prev_MachineBestPScore = 0;
	local prev_MachineBestName = "";
	local cur_song = GAMESTATE:GetCurrentSong();
	local cur_steps = GAMESTATE:GetCurrentSteps( pn );
	local curstats = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn); 
	local curperfects = curstats:GetTapNoteScores('TapNoteScore_W2') + curstats:GetTapNoteScores('TapNoteScore_CheckpointHit');
	local curgreats = curstats:GetTapNoteScores('TapNoteScore_W3');
	local curgoods = curstats:GetTapNoteScores('TapNoteScore_W4');
	local curbads = curstats:GetTapNoteScores('TapNoteScore_W5');
	local curmisses = curstats:GetTapNoteScores('TapNoteScore_Miss') + curstats:GetTapNoteScores('TapNoteScore_CheckpointMiss');
	local curmaxcombo = curstats:MaxCombo();
	local curpscore = CalcPScore(curperfects,curgreats,curgoods,curbads,curmisses,curmaxcombo);
	local PlayerHasNewPScoreRecord = false;
	local PlayerHasNewPScoreMachineRecord = false;
			
	if GAMESTATE:HasProfile( pn ) then
		local HSList = PROFILEMAN:GetProfile( pn ):GetHighScoreList(cur_song,cur_steps):GetHighScores();
		if HSList ~= nil and #HSList ~= 0 then
			local perfects = 0;
			local greats = 0;
			local goods = 0;
			local bads = 0;
			local misses = 0;
			local maxcombo = 0;
			local pscore = 0;
			for i = 1,#HSList do
				perfects = HSList[i]:GetTapNoteScore('TapNoteScore_W2') + HSList[i]:GetTapNoteScore('TapNoteScore_CheckpointHit');
				greats = HSList[i]:GetTapNoteScore('TapNoteScore_W3');
				goods = HSList[i]:GetTapNoteScore('TapNoteScore_W4');
				bads = HSList[i]:GetTapNoteScore('TapNoteScore_W5');
				misses = HSList[i]:GetTapNoteScore('TapNoteScore_Miss') + HSList[i]:GetTapNoteScore('TapNoteScore_CheckpointMiss');		
				maxcombo = HSList[i]:GetMaxCombo();
				pscore = CalcPScore(perfects,greats,goods,bads,misses,maxcombo);
				if pscore >= PersonalBestPScore then
					prev_PersonalBestIndex = PersonalBestIndex; 
					prev_PersonalBestPScore = PersonalBestPScore;
					PersonalBestIndex = i;
					PersonalBestPScore = pscore;
				elseif pscore >= prev_PersonalBestPScore then
					prev_PersonalBestPScore = pscore;
					prev_PersonalBestIndex = i;
				end;
			end;
			if curpscore == PersonalBestPScore and PersonalBestPScore ~= prev_PersonalBestPScore then PlayerHasNewPScoreRecord = true end;
			if PlayerHasNewPScoreRecord ~= true then prev_PersonalBestPScore = PersonalBestPScore end;
			--personal hs
			a[#a+1] = DrawRollingNumberSmall(-40,-14,prev_PersonalBestPScore,PersonalBestPScore,left,.6)..{
				InitCommand=cmd(zoom,.62;maxwidth,85;diffusealpha,0;sleep,.5;diffusealpha,1);
				OffCommand=cmd(stoptweening;visible,false);
			};
			--personal best p.grade
			local PersonalBestPGrade = "";
			PersonalBestPGrade = CalcPGrade(PersonalBestPScore);
			local pgradecolor = ColorPGrade(PersonalBestPGrade);

			a[#a+1] = LoadFont("","pbhdkarnivore 24px") .. {
				InitCommand=cmd(settext,"";horizalign,right;zoom,.32;x,43;y,-12);
				RefreshTextCommand=function(self)
					self:settext( string.upper( PersonalBestPGrade ));
					self:diffuse(color(pgradecolor));
				end;
				OnCommand=cmd(stoptweening;settext,"";sleep,.5;queuecommand,'RefreshText');
				OffCommand=cmd(stoptweening;visible,false);
			};

			--personal best plate
			local PersonalBestPlate = "";
			local greats = HSList[PersonalBestIndex]:GetTapNoteScore('TapNoteScore_W3');
			local goods = HSList[PersonalBestIndex]:GetTapNoteScore('TapNoteScore_W4');
			local bads = HSList[PersonalBestIndex]:GetTapNoteScore('TapNoteScore_W5');
			local misses = HSList[PersonalBestIndex]:GetTapNoteScore('TapNoteScore_Miss') + HSList[PersonalBestIndex]:GetTapNoteScore('TapNoteScore_CheckpointMiss');		
			PersonalBestPlate = CalcPlateInitials(greats,goods,bads,misses);
			local platecolor = 	ColorPlate(PersonalBestPlate);

			a[#a+1] = LoadFont("","_karnivore lite white") .. {
				InitCommand=cmd(settext,"";horizalign,right;zoom,.36;x,43;y,-23);
				RefreshTextCommand=function(self)
					self:settext( string.upper( PersonalBestPlate ));
					self:diffuse(color(platecolor));
				end;
				OnCommand=cmd(stoptweening;settext,"";sleep,.5;queuecommand,'RefreshText');
				OffCommand=cmd(stoptweening;visible,false);
			};
	
			a[#a+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/hs_glow_player.png") )..{
				InitCommand=cmd(basezoom,.66);
				OnCommand=function(self)
					self:visible(false);
					if PlayerHasNewPScoreRecord == true then
						self:sleep(.2);
						self:queuecommand("Effect");
					end;
				end;
				EffectCommand=cmd(y,-17;glowshift;effectcolor1,1,1,0,1;effectcolor2,1,1,1,1;effectperiod,1;visible,true);
				OffCommand=cmd(finishtweening;visible,false);
			};			
			end;
	end;
	
	local HSListMachine = PROFILEMAN:GetMachineProfile():GetHighScoreList(cur_song,cur_steps):GetHighScores();
	if HSListMachine ~= nil and #HSListMachine ~= 0 then
		local perfects = 0;
		local greats = 0;
		local goods =  0;
		local bads =  0;
		local misses = 0;		
		local maxcombo =  0;
		local pscore = 0;
		for i = 1,#HSListMachine do
			perfects =  HSListMachine[i]:GetTapNoteScore('TapNoteScore_W2') +  HSListMachine[i]:GetTapNoteScore('TapNoteScore_CheckpointHit');
			greats =  HSListMachine[i]:GetTapNoteScore('TapNoteScore_W3');
			goods = HSListMachine[i]:GetTapNoteScore('TapNoteScore_W4');
			bads =  HSListMachine[i]:GetTapNoteScore('TapNoteScore_W5');
			misses =  HSListMachine[i]:GetTapNoteScore('TapNoteScore_Miss') +  HSListMachine[i]:GetTapNoteScore('TapNoteScore_CheckpointMiss');		
			maxcombo =  HSListMachine[i]:GetMaxCombo();
			pscore = CalcPScore(perfects,greats,goods,bads,misses,maxcombo);
			if pscore >= MachineBestPScore then
				prev_MachineBestIndex = MachineBestIndex;
				prev_MachineBestPScore = MachineBestPScore;
				MachineBestIndex = i;
				MachineBestPScore = pscore;
				MachineBestName =  HSListMachine[i]:GetName();
			elseif pscore >= prev_MachineBestPScore then
				prev_MachineBestPScore = pscore;
				prev_MachineBestIndex = i;
			end;
		end;
		--machine best name
		a[#a+1] = LoadFont("","_myriad pro 20px") .. {
			InitCommand=cmd(settext,"";horizalign,left;zoom,.62;x,-40;y,12);
			RefreshTextCommand=function(self)
				self:settext( string.upper( MachineBestName ));
			end;
			OnCommand=cmd(stoptweening;settext,"";sleep,.5;queuecommand,'RefreshText');
			OffCommand=cmd(stoptweening;visible,false);
		};
	
		if curpscore == MachineBestPScore and MachineBestPScore ~= prev_MachineBestPScore then PlayerHasNewPScoreMachineRecord = true end;
		if PlayerHasNewPScoreMachineRecord ~= true then prev_MachineBestPScore = MachineBestPScore end;
		--machine best hs
		a[#a+1] = DrawRollingNumberSmall(-40,21,prev_MachineBestPScore,MachineBestPScore,left,.6)..{
			InitCommand=cmd(zoom,.62;maxwidth,85;diffusealpha,0;sleep,.5;diffusealpha,1);
			OffCommand=cmd(stoptweening;visible,false);
		};

		--machine best p.grade
		local MachineBestPGrade = "";
		MachineBestPGrade = CalcPGrade(MachineBestPScore);
		local pgradecolor = ColorPGrade(MachineBestPGrade);
		a[#a+1] = LoadFont("","pbhdkarnivore 24px") .. {
			InitCommand=cmd(settext,"";horizalign,right;zoom,.32;x,43;y,22);
			RefreshTextCommand=function(self)
				self:settext( string.upper( MachineBestPGrade ));
				self:diffuse(color(pgradecolor));
			end;
			OnCommand=cmd(stoptweening;settext,"";sleep,.5;queuecommand,'RefreshText');
			OffCommand=cmd(stoptweening;visible,false);
		};

		--machine best plate
		local MachineBestPlate = "";
		local MBgreats = HSListMachine[MachineBestIndex]:GetTapNoteScore('TapNoteScore_W3');
		local MBgoods = HSListMachine[MachineBestIndex]:GetTapNoteScore('TapNoteScore_W4');
		local MBbads = HSListMachine[MachineBestIndex]:GetTapNoteScore('TapNoteScore_W5');
		local MBmisses = HSListMachine[MachineBestIndex]:GetTapNoteScore('TapNoteScore_Miss') + HSListMachine[MachineBestIndex]:GetTapNoteScore('TapNoteScore_CheckpointMiss');		
		MachineBestPlate = CalcPlateInitials(MBgreats,MBgoods,MBbads,MBmisses);
		local platecolor = ColorPlate(MachineBestPlate);
		a[#a+1] = LoadFont("","_karnivore lite white") .. {
			InitCommand=cmd(settext,"";horizalign,right;zoom,.36;x,43;y,12);
			RefreshTextCommand=function(self)
				self:settext( string.upper( MachineBestPlate ));
				self:diffuse(color(platecolor));
			end;
			OnCommand=cmd(stoptweening;settext,"";sleep,.5;queuecommand,'RefreshText');
			OffCommand=cmd(stoptweening;visible,false);
		};

		a[#a+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/hs_glow_machine.png") )..{
			InitCommand=cmd(basezoom,.66);
			OnCommand=function(self)
				self:visible(false);
				if PlayerHasNewPScoreMachineRecord == true then
					self:sleep(.2);
					self:queuecommand("Effect");
				end;
			end;
			EffectCommand=cmd(y,14;glowshift;effectcolor1,1,1,0,1;effectcolor2,1,1,1,1;effectperiod,1;visible,true);
			OffCommand=cmd(finishtweening;visible,false);
		};
		
		
	end;
	
	a[#a+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/highscores_glow") )..{
		InitCommand=cmd(basezoom,.66;diffuse,0,1,1,1;blend,'BlendMode_Add');
		OnCommand=cmd(stoptweening;horizalign,center;diffusealpha,0;zoomx,0;x,0;sleep,.2;linear,.1;zoomx,1;diffusealpha,.8;linear,.1;zoomx,0;diffusealpha,0;queuecommand,'Loop');
		LoopCommand=cmd(stoptweening;zoomx,1;diffusealpha,0;linear,1;diffusealpha,.1;linear,1;diffusealpha,0;queuecommand,'Loop');
		OffCommand=cmd(stoptweening;zoomx,0;x,0);
	};

	return a;
	end;

-- High scores, Level Ball & Autoplay text
if GAMESTATE:IsSideJoined( PLAYER_1 ) then
t[#t+1] = GetHighScoresFrameEval( PLAYER_1 )..{ InitCommand=cmd(x,cx-275;y,SCREEN_BOTTOM-80); };

--t[#t+1] = GetPHighScoresFrameEval( PLAYER_1 )..{ InitCommand=cmd(x,cx-320;y,SCREEN_BOTTOM-85); };




-- High Score Border Glow when new Record
t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/hs_glow_player.png") )..{
	InitCommand=cmd(basezoom,.66);
	OnCommand=function(self)
		self:visible(false);
		if SCREENMAN:GetTopScreen():PlayerHasNewRecord(PLAYER_1) then
			self:sleep(.2);
			self:queuecommand("Effect");
		end;
	end;
	EffectCommand=cmd(x,cx-275;y,SCREEN_BOTTOM-97;glowshift;effectcolor1,1,1,0,1;effectcolor2,1,1,1,1;effectperiod,1;visible,true);
	OffCommand=cmd(finishtweening;visible,false);
};

t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/hs_glow_machine.png") )..{
	InitCommand=cmd(basezoom,.66);
	OnCommand=function(self)
		self:visible(false);
		if SCREENMAN:GetTopScreen():PlayerHasNewMachineRecord(PLAYER_1) then
			self:sleep(.2);
			self:queuecommand("Effect");
		end;
	end;
	EffectCommand=cmd(x,cx-275;y,SCREEN_BOTTOM-67;glowshift;effectcolor1,1,1,0,1;effectcolor2,1,1,1,1;effectperiod,1;visible,true);
	OffCommand=cmd(finishtweening;visible,false);
};

t[#t+1] = GetBallLevelColor( PLAYER_1, false )..{ 
	InitCommand=cmd(basezoom,.50;x,SCREEN_CENTER_X-135;playcommand,"ShowUp";y,SCREEN_TOP+150;linear,.2;); 
	OffCommand=cmd(stoptweening;playcommand,"Hide";y,SCREEN_BOTTOM-100;sleep,0;linear,.2;y,SCREEN_BOTTOM+100;queuecommand,'HideOnCommand')
};

t[#t+1] = GetBallLevelText( PLAYER_1, false )..{ 
	InitCommand=cmd(basezoom,.50;x,SCREEN_CENTER_X-135;playcommand,"ShowUp";y,SCREEN_TOP+150;linear,.2;); 
	OffCommand=cmd(stoptweening;playcommand,"Hide";y,SCREEN_BOTTOM-100;sleep,0;linear,.2;y,SCREEN_BOTTOM+100;queuecommand,'HideOnCommand') -- Quando sai da tela
};

if STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):IsDisqualified() then
t[#t+1] = LoadFont("_jnr_font")..{
	InitCommand=cmd(settext,"AutoPlay";x,cx-270;y,SCREEN_BOTTOM-142;zoom,.5);
	OffCommand=cmd(stoptweening;visible,false);
};
end;

if GAMESTATE:GetCurrentSteps(PLAYER_1):GetAuthorCredit() ~= "" then
t[#t+1] = LoadFont("SongTitle")..{
	InitCommand=cmd(settext,"by";x,SCREEN_CENTER_X-135;y,SCREEN_TOP+183;zoom,.3);
	OffCommand=cmd(stoptweening;visible,false);
};
t[#t+1] = LoadFont("SongTitle")..{
	InitCommand=function(self)
		local text = GAMESTATE:GetCurrentSteps(PLAYER_1):GetAuthorCredit();
		if string.len(text) >= 38 then
			text = string.sub(text,1,35);
			text = text .. "...";
		end;
		self:settext( text );
		self:maxwidth(216);
	(cmd(x,SCREEN_CENTER_X-135;y,SCREEN_TOP+190;zoom,.3))(self);
	end;
	OffCommand=cmd(stoptweening;visible,false);
};
end;
end;


--Definição do P2 mostrar Frame Evaluation
if GAMESTATE:IsSideJoined( PLAYER_2 ) then
t[#t+1] = GetHighScoresFrameEval( PLAYER_2 )..{ InitCommand=cmd(x,cx+285;y,SCREEN_BOTTOM-80); };

--t[#t+1] = GetPHighScoresFrameEval( PLAYER_2 )..{ InitCommand=cmd(x,cx+320;y,SCREEN_BOTTOM-85); };


t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/hs_glow_player.png") )..{
	InitCommand=cmd(basezoom,.66);
	OnCommand=function(self)
		self:visible(false);
		if SCREENMAN:GetTopScreen():PlayerHasNewRecord(PLAYER_2) then
			self:sleep(.2);
			self:queuecommand("Effect");
		end;
	end;
	EffectCommand=cmd(x,cx+285;y,SCREEN_BOTTOM-97;glowshift;effectcolor1,1,1,0,1;effectcolor2,1,1,1,1;effectperiod,1;visible,true);
	OffCommand=cmd(finishtweening;visible,false);
};
t[#t+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/hs_glow_machine.png") )..{
	InitCommand=cmd(basezoom,.66);
	OnCommand=function(self)
		self:visible(false);
		if SCREENMAN:GetTopScreen():PlayerHasNewMachineRecord(PLAYER_2) then
			self:sleep(.2);
			self:queuecommand("Effect");
		end;
	end;
	EffectCommand=cmd(x,cx+285;y,SCREEN_BOTTOM-67;glowshift;effectcolor1,1,1,0,1;effectcolor2,1,1,1,1;effectperiod,1;visible,true);
	OffCommand=cmd(finishtweening;visible,false);
};

t[#t+1] = GetBallLevelColor( PLAYER_2, false )..{ 
	InitCommand=cmd(basezoom,.50;x,SCREEN_CENTER_X+135;playcommand,"ShowUp";y,SCREEN_TOP+150;linear,.2;zoomx,-1); 
	OffCommand=cmd(stoptweening;playcommand,"Hide";y,SCREEN_BOTTOM-100;sleep,0;linear,.2;y,SCREEN_BOTTOM+100;queuecommand,'HideOnCommand') -- Quando sai da tela
};

t[#t+1] = GetBallLevelText( PLAYER_2, false )..{ 
	InitCommand=cmd(basezoom,.50;x,SCREEN_CENTER_X+135;playcommand,"ShowUp";y,SCREEN_TOP+150;linear,.2;); 
	OffCommand=cmd(stoptweening;playcommand,"Hide";y,SCREEN_BOTTOM-100;sleep,0;linear,.2;y,SCREEN_BOTTOM+100;queuecommand,'HideOnCommand') -- Quando sai da tela
};

if STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):IsDisqualified() then
t[#t+1] = LoadFont("_jnr_font")..{
	InitCommand=cmd(settext,"AutoPlay";x,SCREEN_CENTER_X+135;y,SCREEN_BOTTOM-142;zoom,.5);
	OffCommand=cmd(stoptweening;visible,false);
};
end;
if GAMESTATE:GetCurrentSteps(PLAYER_2):GetAuthorCredit() ~= "" then
t[#t+1] = LoadFont("SongTitle")..{
	InitCommand=cmd(settext,"by";x,SCREEN_CENTER_X+135;y,SCREEN_TOP+183;zoom,.3);
	OffCommand=cmd(stoptweening;visible,false);
};
t[#t+1] = LoadFont("SongTitle")..{
	InitCommand=function(self)
		local text = GAMESTATE:GetCurrentSteps(PLAYER_2):GetAuthorCredit();
		if string.len(text) >= 38 then
			text = string.sub(text,1,35);
			text = text .. "...";
		end;
		self:settext( text );
		self:maxwidth(216);
	(cmd(x,SCREEN_CENTER_X+135;y,SCREEN_TOP+190;zoom,.3))(self);
	end;
	OffCommand=cmd(stoptweening;visible,false);
};
end;
end;

t[#t+1] = LoadActor( "_recordgrades.lua" )..{
	GoNextScreenMessageCommand=cmd(visible,false);
	OffCommand=cmd(stoptweening;visible,false);
};

t[#t+1] = LoadActor( "_recordplates.lua" )..{
	GoNextScreenMessageCommand=cmd(visible,false);
	OffCommand=cmd(stoptweening;visible,false);
};



-- Timer
t[#t+1] = LoadActor(THEME:GetPathG("","Common Resources/TIMER_MASK.png") )..{
	OnCommand=cmd(zoom,0.05;x,cx;y,22;play;MaskSource;);
};

t[#t+1] = LoadActor(THEME:GetPathG("","Common Resources/TIMER_FRAME.mpg") )..{
	OnCommand=cmd(zoom,0.05;x,cx;y,22;play;MaskDest;);
};

--loading twice to speed up the animation (exploiting an ffmpeg bug)
t[#t+1] = LoadActor(THEME:GetPathG("","Common Resources/TIMER_FRAME.mpg") )..{
	OnCommand=cmd(zoom,0.05;x,cx;y,22;play;MaskDest;);
};

t[#t+1] = Def.ActorProxy {
	BeginCommand=function(self) 
		local Timer = SCREENMAN:GetTopScreen():GetChild('Timer'); 
		self:SetTarget(Timer); 
		end;
	OnCommand=cmd(x,SCREEN_CENTER_X;y,20;basezoom,.66;zoom,0;sleep,.2;linear,.05;zoom,1);
	OffCommand=cmd(finishtweening;zoom,1;linear,.2;zoom,0);
}

-- QR Code shenanigans
local QRView = { PLAYER_1 = false, PLAYER_2 = false }

t[#t+1] = LoadFont("_century gothic 20px")..{
	InitCommand=function(self) 
        self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y + 110)
        self:zoom(0.66)
        self:settext(ScreenString("QRInstructions"))
    end,
    OffCommand=cmd(finishtweening;linear,.25;rotationx,90)
};

local Players = GAMESTATE:GetHumanPlayers()
for player in ivalues(Players) do
    t[#t+1] = Def.ActorFrame {
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X + (player == PLAYER_1 and -105 or 105), SCREEN_CENTER_Y + 175)
            self:zoomx(0)
        end,
        CodeMessageCommand=function(self, params)
            if params.PlayerNumber == player then
                if params.Name == "UpLeft" or params.Name == "UpRight" then
                    QRView[player] = not QRView[player]
                    if QRView[player] then
                        self:finishtweening()
                        self:linear(0.2)
                        self:zoomx(1)
                    else
                        self:finishtweening()
                        self:linear(0.2)
                        self:zoomx(0)
                    end
                end
            end
        end,
        OffCommand=cmd(stoptweening;linear,.2;y,SCREEN_BOTTOM+100),
            
        LoadActor("QR/default.lua", player) .. {}
    }
end

return t;
