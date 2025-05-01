--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
local aSteps = {};
local numSteps;

local iChartsToShow = 13;
local bIsExtensiveList = false;
local zoom_factor = 0.66;

--[[
if PREFSMAN:GetPreference("ExtendedStepsList") then
	iChartsToShow = 14;
end;]]--

local curLimInferior = 1;
local curLimSuperior = iChartsToShow;

local t = Def.ActorFrame {
	InitCommand=cmd(zoom,zoom_factor);
	PlayableStepsChangedMessageCommand=function(self)
		if GAMESTATE:IsBasicMode() then return; end;
		aSteps = nil;
		aSteps = SCREENMAN:GetTopScreen():GetPlayableSteps();
		numSteps = #aSteps;
		
		----
		curLimInferior = 1;
		curLimSuperior = iChartsToShow;
		----
		
		if( numSteps > iChartsToShow ) then
			bIsExtensiveList = true;
		else
			bIsExtensiveList = false;
		end;
		---
		
		self:playcommand('UpDate');
	end;
	ChangeStepsMessageCommand=function(self,params)  --solo ocurre en SelectStepsState
		if GAMESTATE:IsBasicMode() then return; end;
		
		----
		if( bIsExtensiveList ) then -- posiblemente se pase a la siguiente hoja de pasos
				local limInf = 1;
				local limSup = iChartsToShow;
				local pos = SCREENMAN:GetTopScreen():GetSelection(params.Player)+1;
				
				local bAnyChange = false;
				
				if pos > curLimInferior or pos < curLimSuperior then
					bAnyChange = true;
				end;
				
				while (limInf>pos) or (limSup<pos)  do
					bAnyChange = true;
					limInf = limInf + iChartsToShow;
					limSup = limSup + iChartsToShow;
				end;
				
				if bAnyChange then
					if limInf == curLimInferior and limSup == curLimSuperior then
						bAnyChange = false;
					else
						curLimInferior = limInf;
						curLimSuperior = limSup;
					end;
				end;
				
				if bAnyChange then				
					local tempSteps = {};
					tempSteps = SCREENMAN:GetTopScreen():GetPlayableSteps();
					aSteps = nil;
					aSteps = {};
					for j=1,iChartsToShow do
						aSteps[j] = tempSteps[j+limInf-1];
					end;
					
					numSteps = #aSteps;
					self:playcommand('UpDate');
				end;
		end;
		
		self:playcommand('UpDateCursor',{Player = params.Player});
	end;
	--OffCommand=cmd(playcommand,'FadeOut');
}

--////////////////////////////////////////////////////////
-- Regresa un n�mero seg�n el estilo de los pasos "i"
local function GetDiffNum(i)
	--No regresa ningun step
	if i > numSteps then return 4; end;
	
	local style = aSteps[i]:GetStepsType();
	local description = aSteps[i]:GetDescription();
	local meter = aSteps[i]:GetMeter();

	--Clasificacion de pasos x estilo, single, double, couple o halfdouble
	--TODO: "StepsType_Pump_Couple"
	
	if style=='StepsType_Pump_Single' and string.find( description,"SP" ) then return 2;
	elseif style=='StepsType_Pump_Single' then return 0;
	elseif style=='StepsType_Pump_Routine' or (not (string.find(description, "RANDOMSONGS")) and style=='StepsType_Pump_Double' and ((meter == (99 or 50)) or string.find(string.upper(description),"COOP") or string.find(string.upper(description),"CO-OP") or string.find(string.upper(description),"ROUTINE") ) ) then return 6;
	elseif ( style=='StepsType_Pump_Double' and string.find( string.upper(description),"DP" ) ) or style=='StepsType_Pump_Couple' then return 3;
	elseif style=='StepsType_Pump_Halfdouble' then return 1;
	elseif style=='StepsType_Pump_Double' then return 1;
	end;
	
	return 4;
end;

--////////////////////////////////////////////////////////
-- ActorFunction: Setea el meter, i=indice
function Actor:SetMeterValue(i,style)
	if i > numSteps then self:settext(""); return; end;

	if GetDiffNum(i) ~= style then
		self:settext("");
		return;
	end;
	
	local num = aSteps[i]:GetMeter();
	local description = aSteps[i]:GetDescription();
	local chartname = aSteps[i]:GetChartName();
	local chartcredits = aSteps[i]:GetAuthorCredit();
	local style = aSteps[i]:GetStepsType();
	if num > 99 then self:settext("??"); return; end;
	if style=='StepsType_Pump_Routine' or (not (string.find(description, "RANDOMSONGS")) and style=='StepsType_Pump_Double' and ((num == (99 or 50)) or string.find(string.upper(description),"COOP") or string.find(string.upper(description),"CO-OP") or string.find(string.upper(description),"ROUTINE") ) ) then
		local coop_players = "?";
		if string.find(string.upper(description), "2P") or string.find(string.upper(chartname), "2P") or string.find(string.upper(chartcredits), "2 PLAYERS")  or string.find(string.upper(description), "2 P") or string.find(string.upper(chartname), "2 P") or string.find(string.upper(description), "TWO P") or string.find(string.upper(chartname), "TWO P") then coop_players = "2"
		elseif string.find(string.upper(description), "3P") or string.find(string.upper(chartname), "3P") or string.find(string.upper(chartcredits), "3 PLAYERS")  or string.find(string.upper(description), "3 P") or string.find(string.upper(chartname), "3 P") or string.find(string.upper(description), "THREE P") or string.find(string.upper(chartname), "THREE P") then coop_players = "3"
		elseif string.find(string.upper(description), "4P") or string.find(string.upper(chartname), "4P") or string.find(string.upper(chartcredits), "4 PLAYERS")  or string.find(string.upper(description), "4 P") or string.find(string.upper(chartname), "4 P") or string.find(string.upper(description), "FOUR P") or string.find(string.upper(chartname), "FOUR P") then coop_players = "4"
		elseif string.find(string.upper(description), "5P") or string.find(string.upper(chartname), "5P") or string.find(string.upper(chartcredits), "5 PLAYERS")  or string.find(string.upper(description), "5 P") or string.find(string.upper(chartname), "5 P") or string.find(string.upper(description), "FIVE P") or string.find(string.upper(chartname), "FIVE P") then coop_players = "5"
		elseif string.find(string.upper(description), "6P") or string.find(string.upper(chartname), "6P") or string.find(string.upper(chartcredits), "6 PLAYERS")  or string.find(string.upper(description), "6 P") or string.find(string.upper(chartname), "6 P") or string.find(string.upper(description), "SIX P") or string.find(string.upper(chartname), "SIX P") then coop_players = "6"
		elseif string.find(string.upper(description), "7P") or string.find(string.upper(chartname), "7P") or string.find(string.upper(chartcredits), "7 PLAYERS")  or string.find(string.upper(description), "7 P") or string.find(string.upper(chartname), "7 P") or string.find(string.upper(description), "SEVEN P") or string.find(string.upper(chartname), "SEVEN P") then coop_players = "7"
		elseif string.find(string.upper(description), "8P") or string.find(string.upper(chartname), "8P") or string.find(string.upper(chartcredits), "8 PLAYERS")  or string.find(string.upper(description), "8 P") or string.find(string.upper(chartname), "8 P") or string.find(string.upper(description), "EIGHT P") or string.find(string.upper(chartname), "EIGHT P") then coop_players = "8"
		elseif string.find(string.upper(description), "9P") or string.find(string.upper(chartname), "9P") or string.find(string.upper(chartcredits), "9 PLAYERS")  or string.find(string.upper(description), "9 P") or string.find(string.upper(chartname), "9 P") or string.find(string.upper(description), "NINE P") or string.find(string.upper(chartname), "NINE P") then coop_players = "9"
		elseif string.find(string.upper(description), "1P") or string.find(string.upper(chartname), "1P") or string.find(string.upper(chartcredits), "1 PLAYER")  or string.find(string.upper(description), "1 P") or string.find(string.upper(chartname), "1 P") or string.find(string.upper(description), "ONE P") or string.find(string.upper(chartname), "ONE P") then coop_players = "1"
		end;
		self:settext("X"..coop_players); return;
	elseif num == 99 then self:settext("??"); return;
	end;
	if num == -1 then self:settext("!!"); return; end;
	
	self:settext( string.format("%.2d",num) );
end;


--////////////////////////////////////////////////////////
local function GetSmallBallLabel( i )
	local official = IsGroupOfficial();
	if i > numSteps then return GetLabelNumber(""); end;	--empty
	if string.find(aSteps[i]:GetDescription(),"TITLE") then
		return 10
	elseif string.find(aSteps[i]:GetChartStyle(),"ACTIVE") then
		return 12
	elseif GetLabelNumber( aSteps[i]:GetLabel() ) == 12 then
		if not official then
			return 5
		else
			return 11
		end;
	else
		return GetLabelNumber( aSteps[i]:GetLabel() );
	end
end;

local function GetUnderBallLabel( i )
	if i > numSteps then return 2; end;	--empty
	local cur_step = aSteps[i];

	local style = cur_step:GetStepsType();
	local description = cur_step:GetDescription();
	
	if ( style=='StepsType_Pump_Double' and string.find( string.upper(description),"HALFDOUBLE" ) ) or style=='StepsType_Pump_Halfdouble' then
		return 0;
	elseif ( style=='StepsType_Pump_Couple' ) then
		return 1
	end;
	
	return 2;
end;

local function GetActiveBallLabel( i )
	if i > numSteps then return 0; end;	--empty
	local cur_step = aSteps[i];
	local chartstyle = cur_step:GetChartStyle();
	if string.find(chartstyle,"ACTIVE") then
		return 1;
	end;
	return 0;
end;

--////////////////////////////////////////////////////////
--Regresa el indice que esta activo.
local function GetActiveIndex(pn)
	if not GAMESTATE:IsSideJoined(pn) then return nil; end;
	
	local selection = SCREENMAN:GetTopScreen():GetSelection(pn)+1;
	local index = selection;
	
	while index > iChartsToShow do
		index = index - iChartsToShow;
	end;
	
	return index;
end;

--[[
function IsNewStepByGroupCondition()
	local cur_song = GAMESTATE:GetCurrentSong();
	if not getenv("IsNewFor"..cur_song:GetGroupName().."Group") then
		return false;
	end;
	return true;
end;
]]--

local function GetPersonalGrade(pn, i)
	if GAMESTATE:IsSideJoined(pn) and GAMESTATE:HasProfile(pn) and aSteps[i] then
		local HighScores = PROFILEMAN:GetProfile(pn):GetHighScoreList(GAMESTATE:GetCurrentSong(), aSteps[i]):GetHighScores()
		if #HighScores ~= 0 then
			local BestScore = math.floor(HighScores[1]:GetScore()/100);
			local StagePass = "B_";
			if BestScore > 2000000 then 
				return nil 
			end
			if BestScore > 1000000 then
				BestScore = BestScore - 1000000;
				StagePass = "R_";
			end;
			local Grade = CalcPGrade(BestScore);
			return StagePass..Grade
		else
			return nil
		end
	else
		return nil
	end
end

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Posicionamento das Bolinhas de Level --

local Xqt = 13
local Yposit = 255
local yBase = 22
for i=1, Xqt do
	local Xposit = -253-377.8+(i-1)*105
	local YY = yBase
		if i == 1 then 
			YY = yBase-0
		end
		if i == 2 then
			YY = yBase-5
		end
		if i == 3 then 
			YY = yBase-10
		end
		if i > 3 and i < 11 then
			YY = yBase-15
		end
		if i == 11 then
			YY = yBase-10
		end
		if i == 12 then
			YY = yBase-5
		end
		if i == 13 then
			YY = yBase-0
		end
			
			t[#t+1] = LoadActor(THEME:GetPathG("", "ScreenSelectMusic/blackball")).. {
				InitCommand=cmd(x,Xposit;y,YY;zoom,1.54;z,-100);
				StartSelectingStepsMessageCommand=cmd(stoptweening;diffusealpha,1;y,YY;sleep,.1;linear,.3;y,yBase;z,-100);
				GoBackSelectingSongMessageCommand=cmd(stoptweening;y,yBase;sleep,.1;linear,.3;y,YY;z,-100);
			};

			t[#t+1] = LoadActor(THEME:GetPathG("","ScreenSelectMusic/fullbar balls 7x1.png") ) .. {
				InitCommand=cmd(x,Xposit;y,YY;zoom,1.8;pause);
				UpDateCommand=cmd( setstate,GetDiffNum(i);visible,GetDiffNum(i)~=4 );
				StartSelectingStepsMessageCommand=cmd(stoptweening;diffusealpha,1;y,YY;sleep,.1;linear,.3;y,yBase);
				GoBackSelectingSongMessageCommand=cmd(stoptweening;y,yBase;sleep,.1;linear,.3;y,YY);
			}

			t[#t+1] = LoadFont("N_SINGLE_N") .. {
				InitCommand=cmd(horizalign,center;x,Xposit;y,YY-1.1;zoom,.70);
				StartSelectingStepsMessageCommand=cmd(x,-191+Xpos[i]+1;y,YY;linear,.3;y,yBase-200);
				GoBackSelectingSongMessageCommand=cmd(x,-191+Xpos[i]+1;y,YY;linear,.3;y,200-1.1);
				StartSelectingStepsMessageCommand=cmd(stoptweening;diffusealpha,1;y,YY;sleep,.1;linear,.3;y,yBase);
				GoBackSelectingSongMessageCommand=cmd(stoptweening;y,yBase;sleep,.1;linear,.3;y,YY);
				UpDateCommand=cmd( SetMeterValue,i,0 );
			};
			
			t[#t+1] = LoadFont("N_SINGLE_P") .. {
				InitCommand=cmd(horizalign,center;x,Xposit;y,YY-1.1;zoom,.70);
				StartSelectingStepsMessageCommand=cmd(x,-191+Xpos[i]+1;y,YY;linear,.3;y,yBase-200);
				GoBackSelectingSongMessageCommand=cmd(x,-191+Xpos[i]+1;y,YY;linear,.3;y,200-1.1);
				StartSelectingStepsMessageCommand=cmd(stoptweening;diffusealpha,1;y,YY;sleep,.1;linear,.3;y,yBase);
				GoBackSelectingSongMessageCommand=cmd(stoptweening;y,yBase;sleep,.1;linear,.3;y,YY);
				UpDateCommand=cmd( SetMeterValue,i,2 );
			};
			
			t[#t+1] = LoadFont("N_DOUBLE_N") .. {
				InitCommand=cmd(horizalign,center;x,Xposit;y,YY-1.1;zoom,.70);
				StartSelectingStepsMessageCommand=cmd(x,-191+Xpos[i]+1;y,YY;linear,.3;y,yBase-200);
				GoBackSelectingSongMessageCommand=cmd(x,-191+Xpos[i]+1;y,YY;linear,.3;y,200-1.1);
				StartSelectingStepsMessageCommand=cmd(stoptweening;diffusealpha,1;y,YY;sleep,.1;linear,.3;y,yBase);
				GoBackSelectingSongMessageCommand=cmd(stoptweening;y,yBase;sleep,.1;linear,.3;y,YY);
				UpDateCommand=cmd( SetMeterValue,i,1 );
			};
			
			t[#t+1] = LoadFont("N_DOUBLE_P") .. {
				InitCommand=cmd(horizalign,center;x,Xposit;y,YY-1.1;zoom,.70);
				StartSelectingStepsMessageCommand=cmd(x,-191+Xpos[i]+1;y,YY;linear,.3;y,yBase-200);
				GoBackSelectingSongMessageCommand=cmd(x,-191+Xpos[i]+1;y,YY;linear,.3;y,200-1.1);
				StartSelectingStepsMessageCommand=cmd(stoptweening;diffusealpha,1;y,YY;sleep,.1;linear,.3;y,yBase);
				GoBackSelectingSongMessageCommand=cmd(stoptweening;y,yBase;sleep,.1;linear,.3;y,YY);
				UpDateCommand=cmd( SetMeterValue,i,3 );
			};
		
			t[#t+1] = LoadFont("N_DOUBLE_N") .. {
				InitCommand=cmd(horizalign,center;x,Xposit;y,YY-1.1;zoom,.70);
				StartSelectingStepsMessageCommand=cmd(x,-191+Xpos[i]+1;y,YY;linear,.3;y,yBase-200);
				GoBackSelectingSongMessageCommand=cmd(x,-191+Xpos[i]+1;y,YY;linear,.3;y,200-1.1);
				StartSelectingStepsMessageCommand=cmd(stoptweening;diffusealpha,1;y,YY;sleep,.1;linear,.3;y,yBase);
				GoBackSelectingSongMessageCommand=cmd(stoptweening;y,yBase;sleep,.1;linear,.3;y,YY);
				UpDateCommand=cmd( SetMeterValue,i,5 );
			};
		
			t[#t+1] = LoadFont("N_COOP") .. {
				InitCommand=cmd(horizalign,center;x,Xposit;y,YY-1.1;zoom,.70);
				StartSelectingStepsMessageCommand=cmd(x,-191+Xpos[i]+1;y,YY;linear,.3;y,yBase-200);
				GoBackSelectingSongMessageCommand=cmd(x,-191+Xpos[i]+1;y,YY;linear,.3;y,200-1.1);
				StartSelectingStepsMessageCommand=cmd(stoptweening;diffusealpha,1;y,YY;sleep,.1;linear,.3;y,yBase);
				GoBackSelectingSongMessageCommand=cmd(stoptweening;y,yBase;sleep,.1;linear,.3;y,YY);
				UpDateCommand=cmd( SetMeterValue,i,6 );
			};
			
			-- Labels --
			t[#t+1] = LoadActor( THEME:GetPathG("","Common Resources/B_LABELS 1x13.png") ) .. {
				InitCommand=cmd(draworder,2;x,Xposit;pause;y,YY-35;zoom,.9;);
				StartSelectingStepsMessageCommand=cmd(stoptweening;diffusealpha,1;y,YY-35;sleep,.1;linear,.3;y,yBase-35);
				GoBackSelectingSongMessageCommand=cmd(stoptweening;y,yBase-35;sleep,.1;linear,.3;y,YY-35);
				UpDateCommand=cmd( setstate,GetSmallBallLabel(i) );
			};

	-- Top Rank
	t[#t+1] = Def.Sprite {
		Name="RankP1";
		Texture=THEME:GetPathG("", "RecordGrades/R_F (doubleres).png");
		InitCommand=cmd(draworder,2;x,Xposit;y,YY-55;zoom,0.65;);
		StartSelectingStepsMessageCommand=cmd(stoptweening;diffusealpha,1;y,YY-55;sleep,.1;linear,.3;y,yBase-55);
		GoBackSelectingSongMessageCommand=cmd(stoptweening;y,yBase-55;sleep,.1;linear,.3;y,YY-55);
		UpDateCommand=function(self)
			local Grade = GetPersonalGrade(PLAYER_1, i)
			if Grade ~= nil then
				self:Load(THEME:GetPathG("", "RecordGrades/" .. Grade .. " (doubleres).png"))
			else
				self:Load(nil)
			end
		end;
	};
	
	-- Bottom Rank
	t[#t+1] = Def.Sprite {
		Name="RankP2";
		Texture=THEME:GetPathG("", "RecordGrades/R_F (doubleres).png");
		InitCommand=cmd(draworder,2;x,Xposit;y,YY+50;zoom,0.65;);
		StartSelectingStepsMessageCommand=cmd(stoptweening;diffusealpha,1;y,YY+50;sleep,.1;linear,.3;y,yBase+50);
		GoBackSelectingSongMessageCommand=cmd(stoptweening;y,yBase+50;sleep,.1;linear,.3;y,YY+50);
		UpDateCommand=function(self)
			local Grade = GetPersonalGrade(PLAYER_2, i)
			if Grade ~= nil then
				self:Load(THEME:GetPathG("", "RecordGrades/" .. Grade .. " (doubleres).png"))
			else
				self:Load(nil)
			end
		end;
	};
	
	-- Under Labels --
	t[#t+1] = LoadActor( THEME:GetPathG("","Common Resources/B_UNDERLABELS 1x3") ).. {
		InitCommand=cmd(x,Xposit;pause;y,yBase+35;zoom,.5;);
		StartSelectingStepsMessageCommand=cmd(stoptweening;diffusealpha,1;y,YY+35;sleep,.1;linear,.3;y,yBase+35);
		GoBackSelectingSongMessageCommand=cmd(stoptweening;y,yBase+35;sleep,.1;linear,.3;y,YY+35);
		UpDateCommand=cmd( setstate,GetUnderBallLabel(i) );
	};
	
end

------------------------------------------------
-- Cursor Function --
local Xpos = {}
for i=1,iChartsToShow do
	Xpos[i] = -253-377.8+(i-1)*105;
	local YY = yBase
		if i == 1 then 
			YY = yBase
		end
		if i == 2 then
			YY = yBase-5
		end
		if i == 3 then 
			YY = yBase-10
		end
		if i > 3 and i < 11 then
			YY = yBase-15
		end
		if i == 11 then
			YY = yBase-10
		end
		if i == 12 then
			YY = yBase-5
		end
		if i == 13 then
			YY = yBase
		end
end


local function GetCursorFor(pn)
	if GAMESTATE:IsSideJoined(pn) or ( not GAMESTATE:IsSideJoined(pn) and GAMESTATE:IsBasicMode() ) then
		local a = Def.ActorFrame {
			InitCommand=function(self)
				if not GAMESTATE:IsSideJoined(pn) then
					self:visible(false);
				end;
			end;
			PlayerJoinedMessageCommand=function(self,params)
				if params.Player == pn then
					self:visible(true);
				end;
			end;
		};
		--
		a[#a+1] = LoadActor( THEME:GetPathG("","ScreenSelectMusic/fullbar_"..pn.."_cursor") )..{
			InitCommand=function(self)
				self:draworder(1);
				if pn == PLAYER_1 then
					self:y(15);	
				else
					self:y(30);
				end;
			end;
			OnCommand=cmd(stoptweening;diffusealpha,0);
			StartSelectingStepsMessageCommand=function(self)
				if not GAMESTATE:IsSideJoined(pn) then return; end;
				(cmd(zoom, 2;stoptweening;x,Xpos[GetActiveIndex(pn)];diffusealpha,0;zoom,2;sleep,.25;linear,.05;diffusealpha,1;queuecommand,'Loop'))(self);
			end;
			UpDateCursorCommand=function(self,params)
				if params.Player ~= pn then return; end;
				(cmd(zoom, 2;stoptweening;diffusealpha,1;x,Xpos[GetActiveIndex(pn)];queuecommand,'Loop'))(self);
			end;
			LoopCommand=cmd(zoom, 2;stoptweening;zoom,2;diffusealpha,1;linear,.4;zoom,2;diffusealpha,.6;linear,.4;zoom,2;diffusealpha,1;queuecommand,'Loop');
			GoBackSelectingSongMessageCommand=cmd(zoom, 2;stoptweening;diffusealpha,0);
			OffCommand=cmd(zoom, 2;stoptweening;diffusealpha,0);
	
		};
		return a;
	else 
		return nil;
	end;
end;
	
	t[#t+1] = GetCursorFor(PLAYER_1);
	t[#t+1] = GetCursorFor(PLAYER_2);
	
	
return t;