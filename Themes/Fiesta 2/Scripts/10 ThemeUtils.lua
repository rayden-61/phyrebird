----------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- Para UnderAttack
local P1PosX = SCREEN_CENTER_X-159;
local P2PosX = SCREEN_CENTER_X+159;
local iNXModAdjust = 55;

function IsUnderAttackForPlayer( pn )
	local POpSt = GAMESTATE:GetPlayerState(pn):GetPlayerOptionsString('ModsLevel_Preferred');
	if ( string.find(POpSt,"UnderAttack") ~= nil ) then
		return true;
	end;
	return false;
end;

function IsNXForPlayer( pn )
	local POpSt = GAMESTATE:GetPlayerState(pn):GetPlayerOptionsString('ModsLevel_Preferred');
	if ( string.find(POpSt,"ModNX") ~= nil ) then
		return true;
	end;
	return false;
end;

function IsDropForPlayer( pn )
	local POpSt = GAMESTATE:GetPlayerState(pn):GetPlayerOptionsString('ModsLevel_Preferred');
	if ( string.find(POpSt,"Drop") ~= nil ) then
		return true;
	end;
	return false;
end;

function GetP1XPosition()
	local bUA = IsUnderAttackForPlayer(PLAYER_1);
	local bNX = IsNXForPlayer(PLAYER_1);
	
	if bUA then
		if bNX then
			return P2PosX-iNXModAdjust;
		else
			return P2PosX;
		end;
	end;
	
	if bNX then
		return P1PosX+iNXModAdjust;
	else
		return P1PosX;
	end;
end;

function GetP2XPosition()
	local bUA = IsUnderAttackForPlayer(PLAYER_2);
	local bNX = IsNXForPlayer(PLAYER_2);
	
	if bUA then
		if bNX then
			return P1PosX+iNXModAdjust;
		else
			return P1PosX;
		end;
	end;
	
	if bNX then
		return P2PosX-iNXModAdjust;
	else
		return P2PosX;
	end;
end;

-----------------------------------------------------------------------
-----------------------------------------------------------------------
--///////////////////////////////////////////////////////////////
-- Usado en las esferas de nivel del SSM y Evaluation
-- Actor:Setea el nivel, traduciendo los números 99 y -1
function Actor:SetLevelText(pn)
	local cur_steps = GAMESTATE:GetCurrentSteps(pn);
	if cur_steps == nil then return; end;
	
	local meter = cur_steps:GetMeter();
	if meter==99 then self:settext('??'); return; end;
	if meter==-1 then self:settext('!!'); return; end;

	self:settext( string.format("%.2d",meter) );
end;

-----------------------------------------------------------------------
-----------------------------------------------------------------------
--///////////////////////////////////////////////////////////////

-- Se utiliza en el default.lua del decorations del select music
function AddDots( score )
	if score >= 999999999 then
		return "999.999.999";
	end;
	
	if score >= 1000000 then
		local millonesimas = math.floor(score/1000000);
		local milesimas = math.floor(score/1000) - millonesimas*1000;
		local centesimas = score - milesimas*1000 - millonesimas*1000000;

		return string.format("%01d",millonesimas).."."..string.format("%03d",milesimas).."."..string.format("%03d",centesimas);
	elseif score < 1000000 and score >= 1000 then
		local milesimas = math.floor(score/1000);
		local centesimas = score - milesimas*1000;
		
		return string.format("%01d",milesimas).."."..string.format("%03d",centesimas);
	else
		return string.format("%01d",score);
	end;
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



function ScoreToPercent( score )
	local formatted_score = ""
	if score < 100 then
		formatted_score = "00.00"
	elseif score < 1000 then
		formatted_score = "00.0" .. math.floor(score/100);
	elseif score < 10000 then
		formatted_score = "00." .. math.floor(score/100);
	elseif score < 100000 then
		local relevant_digits = math.floor(score/100);
		local integer_part = "0" .. string.sub(relevant_digits,1,1);
		local decimal_part = string.sub(relevant_digits,2,2) .. string.sub(relevant_digits,3,3);
		formatted_score = integer_part .. "." .. decimal_part;
	elseif score < 1000000 then
		local relevant_digits = math.floor(score/100);
		local integer_part = string.sub(relevant_digits,1,2);
		local decimal_part = string.sub(relevant_digits,3,4);
		formatted_score = integer_part .. "." .. decimal_part;
	else
		formatted_score = "100.00"
	end
	return formatted_score .. "%"
end

--/////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- P. SCORE FUNCTIONS --


function CalcPScore(perfects, greats, goods, bads, misses, maxcombo)
	local notestotal = perfects + greats + goods + bads + misses;
	if notestotal <= 1 then notestotal = 1 end;
	local weightednotes = perfects + 0.6*greats + 0.2*goods + 0.1*bads;
	local pscore = math.floor(995000*(weightednotes/notestotal) + 5000*(maxcombo/notestotal))
	if pscore < 0 then
		pscore = 0;
	elseif pscore > 1000000 then
		pscore = 1000000;
	end
	return pscore;
end

--

function CalcPGrade(pscore)
	local pgrade = (
			(pscore >= 995000 and "SSS+")	or 
			(pscore >= 990000 and "SSS")	or 
			(pscore >= 985000 and "SS+")	or
			(pscore >= 980000 and "SS")		or
			(pscore >= 975000 and "S+")		or
			(pscore >= 970000 and "S")		or 
			(pscore >= 960000 and "AAA+")	or 
			(pscore >= 950000 and "AAA")	or
			(pscore >= 925000 and "AA+")	or
			(pscore >= 900000 and "AA")		or
			(pscore >= 825000 and "A+")		or
			(pscore >= 750000 and "A")		or
			(pscore >= 650000 and "B")		or
			(pscore >= 550000 and "C")		or
			(pscore >= 450000 and "D") 		or
			"F"
			);
	return pgrade;
end

--

function CalcPGradeInt(pscore)
	local pgrade = (
			(pscore >= 995000 and 1)	or 
			(pscore >= 990000 and 2)	or 
			(pscore >= 985000 and 3)	or
			(pscore >= 980000 and 4)	or
			(pscore >= 975000 and 5)	or
			(pscore >= 970000 and 6)	or 
			(pscore >= 960000 and 7)	or 
			(pscore >= 950000 and 8)	or
			(pscore >= 925000 and 9)	or
			(pscore >= 900000 and 10)	or
			(pscore >= 825000 and 11)	or
			(pscore >= 750000 and 12)	or
			(pscore >= 650000 and 13)	or
			(pscore >= 550000 and 14)	or
			(pscore >= 450000 and 15) 	or
			16
			);
	return pgrade;
end

--

function CalcPlate(greats,goods,bads,misses)
	local plate = (
		(misses >= 21 and "ROUGH GAME")		or 
		(misses >= 11 and "FAIR GAME")		or
		(misses >= 6 and "TALENTED GAME")	or
		(misses >= 1 and "MARVELOUS GAME")	or
		(bads >= 1 and "SUPERB GAME")		or 
		(goods >= 1 and "EXTREME GAME")		or 
		(greats >= 1 and "ULTIMATE GAME")	or
		"PERFECT GAME"
		);
	return plate;
end;

--

function CalcPlateInitials(greats,goods,bads,misses)
	local plate = (
		(misses >= 21 and "RG")		or 
		(misses >= 11 and "FG")		or
		(misses >= 6 and "TG")		or
		(misses >= 1 and "MG")		or
		(bads >= 1 and "SG")		or 
		(goods >= 1 and "EG")		or 
		(greats >= 1 and "UG")		or
		"PG"
		);
	return plate;
end;

--

function ColorPGrade(pgrade)
	local PGradeColor = "";
	if pgrade == "AAA" or pgrade == "AAA+" then
		PGradeColor =  "#FFFFFF"; -- silver color (actually white)
	elseif string.find(pgrade, "A") then
		PGradeColor = "0.847,0.552,0.254,1"; -- bronze color
	elseif pgrade == "SSS" or pgrade == "SSS+" then
		PGradeColor = "#A5FDFD"; -- platinum color
	elseif string.find(pgrade, "S") then
		PGradeColor = "#FEE108"; -- gold color
	else
		PGradeColor = "0.696,0.696,0.692,1"; -- dark color (broken grades)
	end;
	return PGradeColor;
end;

--

function ColorPlate(plate)
	local PlateColor = "";
	if plate == "RG" or plate == "ROUGH GAME" then
		PlateColor = "0.847,0.552,0.254,1";
	elseif plate == "FG" or plate == "FAIR GAME" then
		PlateColor = "0.847,0.552,0.254,1";
	elseif plate == "TG" or plate == "TALENTED GAME"then
		PlateColor = "#FFFFFF";
	elseif plate ==	"MG" or plate == "MARVELOUS GAME" then
		PlateColor = "#FFFFFF";
	elseif plate == "SG" or plate == "SUPERB GAME" then
		PlateColor = "#FEE108";
	elseif plate == "EG" or plate == "EXTREME GAME" then
		PlateColor = "#FEE108";
	elseif plate == "UG" or plate == "ULTIMATE GAME" then
		PlateColor = "#A5FDFD";
	elseif plate == "PG" or plate == "PERFECT GAME" then
		PlateColor = "#A5FDFD";
	else
		PlateColor = "#FFFFFF";
	end;
	return PlateColor;
end;

function CalcSkill(perfects,greats,goods,bads,misses,helds,drops,maxcombo,level)
	local adjusted_drops = drops/10;
	local adjusted_helds = helds/10;
	local notestotal = perfects + greats + goods + bads + misses;
	local adjusted_notestotal = notestotal + adjusted_drops + adjusted_helds;
	if notestotal <= 1 then notestotal = 1 end;
	local weightednotes = perfects+adjusted_helds + 0.6*greats + 0.2*goods + 0.1*bads;
	local accuracy = weightednotes/adjusted_notestotal * 0.995;
	local combo_bonus = maxcombo/notestotal * 0.005;
	local score = accuracy + combo_bonus
	local skill = (score+0.05)*level
	skill = math.floor(skill*1000)/1000; --reducing to 3 decimals
	skill = skill*1000 --weightpounds is an intenger actually? not sure
	return skill;
end;

function CalcEXP(meter,score)
	local base_exp = 0
	if meter > 9 then
		base_exp = 100 + 5 * (meter-10) * (meter - 9)
		else
		base_exp = meter * 10
	end;
	local multiplier = (
			(score >= 199500000 and 1.50)	or 
			(score >= 199000000 and 1.44)	or 
			(score >= 198500000 and 1.38)	or
			(score >= 198000000 and 1.32)	or
			(score >= 197500000 and 1.26)	or
			(score >= 197000000 and 1.20)	or 
			(score >= 196000000 and 1.14)	or 
			(score >= 195000000 and 1.10)	or
			(score >= 192500000 and 1.05)	or
			(score >= 190000000 and 1.00)	or
			(score >= 182500000 and 0.90)	or
			(score >= 175000000 and 0.80)	or
			(score >= 165000000 and 0.70)	or
			(score >= 155000000 and 0.60)	or
			(score >= 145000000 and 0.50) 	or
			0.00
			);
	local total_exp = math.floor(base_exp*multiplier)
	return total_exp
end;

function CalcPlayerLevel(totalexp)
	local player_level_raw = 1+(0.15*totalexp^0.5);
	local player_level_int = math.floor(player_level_raw);
	local to_next_level = math.floor(100*(player_level_raw - player_level_int));
  return player_level_int,to_next_level;
end;

-----------------------------------------------------------------------
	

--/////////////////////////////////////////////////////////////////////////////////////////////////////////////


function GetHighScoresFrame( pn, appear_on_start )
local t = Def.ActorFrame {
	OnCommand=function(self)
		if appear_on_start then self:playcommand("StartSelectingSteps"); end;
		return;
	end;
	children = {
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/highscores_bg") )..{
			InitCommand=cmd(basezoom,.66;zoomx,0);
			ChangeStepsMessageCommand=cmd(stoptweening;zoomx,1);
			StartSelectingStepsMessageCommand=cmd(stoptweening;zoomx,0;linear,.2;zoomx,1);
			GoBackSelectingSongMessageCommand=cmd(stoptweening;zoomx,1;linear,.2;zoomx,0);
			OffCommand=cmd(stoptweening;zoomx,1;linear,.2;zoomx,0);
		};
		--personal hs
		LoadFont("_karnivore lite white")..{
			InitCommand=cmd(settext,"";horizalign,left;zoom,.62;x,-40;y,-14;maxwidth,85);
			RefreshTextCommand=function(self)
				local cur_song = GAMESTATE:GetCurrentSong();
				local cur_steps = GAMESTATE:GetCurrentSteps(pn);
				if GAMESTATE:HasProfile(pn) then
					local HSList = PROFILEMAN:GetProfile( pn ):GetHighScoreList(cur_song,cur_steps):GetHighScores();
					if (#HSList ~= 0) then
						local score = math.floor(HSList[1]:GetScore() / 100);
						if score > 2000000 then 
							score = 0;
							self:settext("");
						elseif score > 1000000 then 
							score = score - 1000000;
							self:settext( AddDots(score) );
						else
							self:settext( AddDots(score) );
						end;
					else
						self:settext("")
					end;
				else
					self:settext("")
				end;
			end;
			ChangeStepsMessageCommand=function(self,params)
				if params.Player ~= pn then return; end;
				(cmd(stoptweening;playcommand,'RefreshText'))(self);
			end;
			StartSelectingStepsMessageCommand=cmd(stoptweening;settext,"";sleep,.2;queuecommand,'RefreshText');
			GoBackSelectingSongMessageCommand=cmd(finishtweening;settext,"");
			OffCommand=cmd(stoptweening;visible,false);
		};
		--machine best name
		LoadFont("","_myriad pro 20px") .. {
			InitCommand=cmd(settext,"";horizalign,left;zoom,.62;x,-40;y,12);
			RefreshTextCommand=function(self)
				local cur_song = GAMESTATE:GetCurrentSong();
				local cur_steps = GAMESTATE:GetCurrentSteps( pn );
				local HSList = PROFILEMAN:GetMachineProfile():GetHighScoreList(cur_song,cur_steps):GetHighScores();
				if #HSList ~= 0 then
					self:settext( string.upper( HSList[1]:GetName() ));
				else
					self:settext("");
				end;
			end;
			ChangeStepsMessageCommand=function(self,params)
				if params.Player ~= pn then return; end;
				(cmd(stoptweening;playcommand,'RefreshText'))(self);
			end;
			StartSelectingStepsMessageCommand=cmd(stoptweening;settext,"";sleep,.2;queuecommand,'RefreshText');
			GoBackSelectingSongMessageCommand=cmd(stoptweening;settext,"");
			OffCommand=cmd(stoptweening;visible,false);
		};
		--machine best hs
		LoadFont("_karnivore lite white")..{
			InitCommand=cmd(settext,"";horizalign,left;zoom,.62;x,-40;y,21;maxwidth,85);
			RefreshTextCommand=function(self)
				local cur_song = GAMESTATE:GetCurrentSong();
				local cur_steps = GAMESTATE:GetCurrentSteps(pn);
				local HSList = PROFILEMAN:GetMachineProfile():GetHighScoreList(cur_song,cur_steps):GetHighScores();
				if (#HSList ~= 0) then
					local score = math.floor(HSList[1]:GetScore()/100);
					if score > 2000000 then 
						score = 0;
						self:settext("");
					elseif score > 1000000 then 
						score = score - 1000000;
						self:settext( AddDots(score) );
					else
						self:settext( AddDots(score) );
					end;
				else
					self:settext("")
				end;
			end;
			ChangeStepsMessageCommand=function(self,params)
				if params.Player ~= pn then return; end;
				(cmd(stoptweening;playcommand,'RefreshText'))(self);
			end;
			StartSelectingStepsMessageCommand=cmd(stoptweening;settext,"";sleep,.2;queuecommand,'RefreshText');
			GoBackSelectingSongMessageCommand=cmd(stoptweening;settext,"");
			OffCommand=cmd(stoptweening;visible,false);
		};
		LoadActor( THEME:GetPathG("","ScreenSelectMusic/highscores_glow") )..{
			InitCommand=cmd(basezoom,.66;diffuse,0,1,1,1;blend,'BlendMode_Add');
			OnCommand=cmd(zoomx,0);
			StartSelectingStepsMessageCommand=cmd(stoptweening;horizalign,center;diffusealpha,0;zoomx,0;x,0;sleep,.2;linear,.1;zoomx,1;diffusealpha,.8;linear,.1;zoomx,0;diffusealpha,0;queuecommand,'Loop');
			LoopCommand=cmd(stoptweening;x,0;horizalign,center;zoomx,1;diffusealpha,0;linear,1;diffusealpha,.1;linear,1;diffusealpha,0;queuecommand,'Loop');
			ChangeStepsMessageCommand=function(self,params)
				if params.Player ~= pn then return; end;
				if params.Direction == -1 then
					(cmd(stoptweening;horizalign,left;diffusealpha,0;zoomx,0;x,-44;linear,.1;zoomx,1;diffusealpha,.8))(self);
					(cmd(horizalign,right;diffusealpha,.8;zoomx,1;x,44;linear,.1;zoomx,0;diffusealpha,0;queuecommand,'Loop'))(self);
				else
					(cmd(stoptweening;horizalign,right;diffusealpha,0;zoomx,0;x,44;linear,.1;zoomx,1;diffusealpha,.8))(self);
					(cmd(horizalign,left;diffusealpha,.8;zoomx,1;x,-44;linear,.1;zoomx,0;diffusealpha,0;queuecommand,'Loop'))(self);
				end;
			end;
			GoBackSelectingSongMessageCommand=cmd(stoptweening;zoomx,0;x,0);
			OffCommand=cmd(stoptweening;zoomx,0;x,0);
		};
	};
};
return t;
end;


--P.Score Frame
function GetPHighScoresFrame( pn, appear_on_start )
	local PersonalBestIndex = 1; 
	local PersonalBestPScore = 0;
	local MachineBestIndex = 1;
	local MachineBestPScore = 0;
	local MachineBestName = "";
	local t = Def.ActorFrame {
		OnCommand=function(self)
			if appear_on_start then self:playcommand("StartSelectingSteps"); end;
			return;
		end;
		children = {
			LoadActor( THEME:GetPathG("","ScreenSelectMusic/highscores_bg") )..{
				InitCommand=cmd(basezoom,.66;zoomx,0);
				ChangeStepsMessageCommand=cmd(stoptweening;zoomx,1);
				StartSelectingStepsMessageCommand=cmd(stoptweening;zoomx,0;linear,.2;zoomx,1);
				GoBackSelectingSongMessageCommand=cmd(stoptweening;zoomx,1;linear,.2;zoomx,0);
				OffCommand=cmd(stoptweening;zoomx,1;linear,.2;zoomx,0);
			};

			--personal hs
			LoadFont("_karnivore lite white")..{
				InitCommand=cmd(settext,"";horizalign,left;zoom,.62;x,-40;y,-14;maxwidth,80);
				RefreshTextCommand=function(self)
					local cur_song = GAMESTATE:GetCurrentSong();
					local cur_steps = GAMESTATE:GetCurrentSteps(pn);
					PersonalBestIndex = 1;
					PersonalBestPScore = 0;
					if GAMESTATE:HasProfile(pn) then
						local HSList = PROFILEMAN:GetProfile( pn ):GetHighScoreList(cur_song,cur_steps):GetHighScores();
						if (#HSList ~= 0) then
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
								pscore = CalcPScore(perfects, greats, goods, bads, misses, maxcombo);
								if pscore >= PersonalBestPScore then
									PersonalBestIndex = i;
									PersonalBestPScore = pscore;
								end;
							end;
							self:settext( AddDots(PersonalBestPScore) );
						else
							self:settext("");
						end;
					else
						self:settext("");
					end;
				end;
				ChangeStepsMessageCommand=function(self,params)
					if params.Player ~= pn then return; end;
					(cmd(stoptweening;playcommand,'RefreshText'))(self);
				end;
				StartSelectingStepsMessageCommand=cmd(stoptweening;settext,"";sleep,.2;queuecommand,'RefreshText');
				GoBackSelectingSongMessageCommand=cmd(finishtweening;settext,"");
				OffCommand=cmd(stoptweening;visible,false);
			};

			--Personal Best P.Grade
			LoadFont("pbhdkarnivore 24px")..{
				InitCommand=cmd(settext,"";horizalign,right;zoom,.32;x,43;y,-12);
				RefreshTextCommand=function(self)
					local cur_song = GAMESTATE:GetCurrentSong();
					local cur_steps = GAMESTATE:GetCurrentSteps(pn);
					if GAMESTATE:HasProfile(pn) then
						local HSList = PROFILEMAN:GetProfile( pn ):GetHighScoreList(cur_song,cur_steps):GetHighScores();
						if (#HSList ~= 0) then
								local pgrade = CalcPGrade(PersonalBestPScore);
								local pgradecolor = ColorPGrade(pgrade);
								self:settext( pgrade );
								self:diffuse(color(pgradecolor))
						else
							self:settext("");
						end;
					else
						self:settext("");
					end;
				end;
				ChangeStepsMessageCommand=function(self,params)
					if params.Player ~= pn then return; end;
					(cmd(stoptweening;sleep,.01;queuecommand,'RefreshText'))(self);
				end;
				StartSelectingStepsMessageCommand=cmd(stoptweening;settext,"";sleep,.2;queuecommand,'RefreshText');
				GoBackSelectingSongMessageCommand=cmd(finishtweening;settext,"");
				OffCommand=cmd(stoptweening;visible,false);
			};

			--Personal Best Plate
			LoadFont("_karnivore lite white")..{
				InitCommand=cmd(settext,"";horizalign,right;zoom,.36;x,43;y,-23);
				RefreshTextCommand=function(self)
					local cur_song = GAMESTATE:GetCurrentSong();
					local cur_steps = GAMESTATE:GetCurrentSteps(pn);
					if GAMESTATE:HasProfile(pn) then
						local HSList = PROFILEMAN:GetProfile( pn ):GetHighScoreList(cur_song,cur_steps):GetHighScores();
						if (#HSList ~= 0) then
							local greats = HSList[PersonalBestIndex]:GetTapNoteScore('TapNoteScore_W3');
							local goods = HSList[PersonalBestIndex]:GetTapNoteScore('TapNoteScore_W4');
							local bads = HSList[PersonalBestIndex]:GetTapNoteScore('TapNoteScore_W5');
							local misses = HSList[PersonalBestIndex]:GetTapNoteScore('TapNoteScore_Miss') + HSList[PersonalBestIndex]:GetTapNoteScore('TapNoteScore_CheckpointMiss');		
							local plate = CalcPlateInitials(greats,goods,bads,misses);
							local platecolor = ColorPlate(plate);
							self:settext( plate );
							self:diffusecolor(color(platecolor));
						else
							self:settext("");
						end;
					else
						self:settext("");
					end;
				end;
				ChangeStepsMessageCommand=function(self,params)
					if params.Player ~= pn then return; end;
					(cmd(stoptweening;sleep,.01;queuecommand,'RefreshText'))(self);
				end;
				StartSelectingStepsMessageCommand=cmd(stoptweening;settext,"";sleep,.2;queuecommand,'RefreshText');
				GoBackSelectingSongMessageCommand=cmd(finishtweening;settext,"");
				OffCommand=cmd(stoptweening;visible,false);
			};
			
			--machine best name
			LoadFont("","_myriad pro 20px") .. {
				InitCommand=cmd(settext,"";horizalign,left;zoom,.62;x,-40;y,12);
				RefreshTextCommand=function(self)
					local cur_song = GAMESTATE:GetCurrentSong();
					local cur_steps = GAMESTATE:GetCurrentSteps( pn );
					local HSList = PROFILEMAN:GetMachineProfile():GetHighScoreList(cur_song,cur_steps):GetHighScores();
					local pscore = 0;
					MachineBestIndex = 1;
					MachineBestPScore = 0;
					MachineBestName = "";
					if (#HSList ~= 0) then
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
							pscore = CalcPScore(perfects, greats,goods,bads,misses,maxcombo);
							if pscore >= MachineBestPScore then
								MachineBestIndex = i;
								MachineBestPScore = pscore;
								MachineBestName = HSList[i]:GetName();
							end;
						end;
						self:settext( string.upper(MachineBestName) );
					else
						self:settext("")
					end;
				end;
				ChangeStepsMessageCommand=function(self,params)
					if params.Player ~= pn then return; end;
					(cmd(stoptweening;playcommand,'RefreshText'))(self);
				end;
				StartSelectingStepsMessageCommand=cmd(stoptweening;settext,"";sleep,.20;queuecommand,'RefreshText');
				GoBackSelectingSongMessageCommand=cmd(stoptweening;settext,"");
				OffCommand=cmd(stoptweening;visible,false);
			};

			--machine best hs
			LoadFont("_karnivore lite white")..{
				InitCommand=cmd(settext,"";horizalign,left;zoom,.62;x,-40;y,21;maxwidth,80);
				RefreshTextCommand=function(self)
					local cur_song = GAMESTATE:GetCurrentSong();
					local cur_steps = GAMESTATE:GetCurrentSteps(pn);
					local HSList = PROFILEMAN:GetMachineProfile():GetHighScoreList(cur_song,cur_steps):GetHighScores();
					if (#HSList ~= 0) then
						self:settext( AddDots(MachineBestPScore) );
					else
						self:settext("")
					end;
				end;
				ChangeStepsMessageCommand=function(self,params)
					if params.Player ~= pn then return; end;
					(cmd(stoptweening;sleep,.01;queuecommand,'RefreshText'))(self);
				end;
				StartSelectingStepsMessageCommand=cmd(stoptweening;settext,"";sleep,.21;queuecommand,'RefreshText');
				GoBackSelectingSongMessageCommand=cmd(stoptweening;settext,"");
				OffCommand=cmd(stoptweening;visible,false);
			};

			--machine best hs p.grade
			LoadFont("pbhdkarnivore 24px")..{
				InitCommand=cmd(settext,"";horizalign,right;zoom,.32;x,43;y,22);
				RefreshTextCommand=function(self)
					local cur_song = GAMESTATE:GetCurrentSong();
					local cur_steps = GAMESTATE:GetCurrentSteps(pn);
					local HSList = PROFILEMAN:GetMachineProfile():GetHighScoreList(cur_song,cur_steps):GetHighScores();
					if (#HSList ~= 0) then
						local pgrade = "";
						pgrade = CalcPGrade(MachineBestPScore);
						local pgradecolor = ColorPGrade(pgrade);
						self:settext( pgrade );
						self:diffuse(color(pgradecolor));
					else
						self:settext("")
					end;
				end;
				ChangeStepsMessageCommand=function(self,params)
					if params.Player ~= pn then return; end;
					(cmd(stoptweening;sleep,.01;queuecommand,'RefreshText'))(self);
				end;
				StartSelectingStepsMessageCommand=cmd(stoptweening;settext,"";sleep,.21;queuecommand,'RefreshText');
				GoBackSelectingSongMessageCommand=cmd(stoptweening;settext,"");
				OffCommand=cmd(stoptweening;visible,false);
			};

			--machine best hs plate
			LoadFont("_karnivore lite white")..{
				InitCommand=cmd(settext,"";horizalign,right;zoom,.36;x,43;y,12);
				RefreshTextCommand=function(self)
					local cur_song = GAMESTATE:GetCurrentSong();
					local cur_steps = GAMESTATE:GetCurrentSteps(pn);
					local HSList = PROFILEMAN:GetMachineProfile():GetHighScoreList(cur_song,cur_steps):GetHighScores();
					if (#HSList ~= 0) then
						greats = HSList[MachineBestIndex]:GetTapNoteScore('TapNoteScore_W3');
						goods = HSList[MachineBestIndex]:GetTapNoteScore('TapNoteScore_W4');
						bads = HSList[MachineBestIndex]:GetTapNoteScore('TapNoteScore_W5');
						misses = HSList[MachineBestIndex]:GetTapNoteScore('TapNoteScore_Miss') + HSList[PersonalBestIndex]:GetTapNoteScore('TapNoteScore_CheckpointMiss');		
						plate = CalcPlateInitials(greats,goods,bads,misses);
						local platecolor = ColorPlate(plate);
						self:settext( plate );
						self:diffuse(color(platecolor));
					else
						self:settext("")
					end;
				end;
				ChangeStepsMessageCommand=function(self,params)
					if params.Player ~= pn then return; end;
					(cmd(stoptweening;sleep,.01;queuecommand,'RefreshText'))(self);
				end;
				StartSelectingStepsMessageCommand=cmd(stoptweening;settext,"";sleep,.21;queuecommand,'RefreshText');
				GoBackSelectingSongMessageCommand=cmd(stoptweening;settext,"");
				OffCommand=cmd(stoptweening;visible,false);
			};

			LoadActor( THEME:GetPathG("","ScreenSelectMusic/highscores_glow") )..{
			InitCommand=cmd(basezoom,.66;diffuse,0,1,1,1;blend,'BlendMode_Add');
			OnCommand=cmd(zoomx,0);
			StartSelectingStepsMessageCommand=cmd(stoptweening;horizalign,center;diffusealpha,0;zoomx,0;x,0;sleep,.2;linear,.1;zoomx,1;diffusealpha,.8;linear,.1;zoomx,0;diffusealpha,0;queuecommand,'Loop');
			LoopCommand=cmd(stoptweening;x,0;horizalign,center;zoomx,1;diffusealpha,0;linear,1;diffusealpha,.1;linear,1;diffusealpha,0;queuecommand,'Loop');
			ChangeStepsMessageCommand=function(self,params)
				if params.Player ~= pn then return; end;
				if params.Direction == -1 then
					(cmd(stoptweening;horizalign,left;diffusealpha,0;zoomx,0;x,-44;linear,.1;zoomx,1;diffusealpha,.8))(self);
					(cmd(horizalign,right;diffusealpha,.8;zoomx,1;x,44;linear,.1;zoomx,0;diffusealpha,0;queuecommand,'Loop'))(self);
				else
					(cmd(stoptweening;horizalign,right;diffusealpha,0;zoomx,0;x,44;linear,.1;zoomx,1;diffusealpha,.8))(self);
					(cmd(horizalign,left;diffusealpha,.8;zoomx,1;x,-44;linear,.1;zoomx,0;diffusealpha,0;queuecommand,'Loop'))(self);
				end;
			end;
			GoBackSelectingSongMessageCommand=cmd(stoptweening;zoomx,0;x,0);
			OffCommand=cmd(stoptweening;zoomx,0;x,0);
			};
		};
	};
	return t;
	end;

-----------------------------------------------------------------------
-----------------------------------------------------------------------
--///////////////////////////////////////////////////////////////
-- Labels

local Labels = {
	["ANOTHER"] = 1,
	["PRO"] = 2,
	["TRAIN"] = 3,
	["QUEST"] = 4,
	["UCS"] = 5,
	["HIDDEN"] = 6,
	["INFINITY"] = 7,
	["JUMP"] = 8,
	["OUCS"] = 9,
	["NEW"] = 0,
	["TITLE"] = 10,
	["LEGACY"] = 11
};

function GetLabelNumber( label )
	if label == "" then return 12; end;
	
	return Labels[label];
end;


--/////////////////////////////////////////////////////////////////////////////////////////////////////////////
--/////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Obtiene el color de la esfera, seg�n el estilo y descripci�n del chart
function GetDiffNumberBall( cur_steps )
	if cur_steps == nil then return 0; end;
	local style = cur_steps:GetStepsType();
	local description = cur_steps:GetDescription();
	local meter = cur_steps:GetMeter();

	if style=='StepsType_Pump_Single' and string.find(description,"SP") then return(1);
	elseif style=='StepsType_Pump_Single' then return (0);
	elseif style=='StepsType_Pump_Routine' or (description ~= "RANDOMSONGS" and style=='StepsType_Pump_Double' and ((meter == (99 or 50)) or string.find(string.upper(description),"COOP") or string.find(string.upper(description),"CO-OP") or string.find(string.upper(description),"ROUTINE") ) ) then return (5);
	elseif ( style=='StepsType_Pump_Double' and string.find( string.upper(description),"DP" ) ) or style=='StepsType_Pump_Couple' then return(3);
	elseif style=='StepsType_Pump_Halfdouble' then return (2);
	elseif style=='StepsType_Pump_Double' then return (2);
	end;
	
	return 0;
end;

-- Get simplified ball color
function GetSimpleDiffNumberBall( cur_steps )
	if cur_steps == nil then return 0; end;
	local style = cur_steps:GetStepsType();
	local description = cur_steps:GetDescription();
	local meter = cur_steps:GetMeter();

	if style=='StepsType_Pump_Single' and string.find(description,"SP") then return(2);
	elseif style=='StepsType_Pump_Single' then return (0);
	elseif style=='StepsType_Pump_Routine' or (style=='StepsType_Pump_Double' and ((meter == (99 or 50)) or string.find(string.upper(description),"COOP") or string.find(string.upper(description),"CO-OP") or string.find(string.upper(description),"ROUTINE") ) ) then return (6);
	elseif ( style=='StepsType_Pump_Double' and string.find( string.upper(description),"DP" ) ) or style=='StepsType_Pump_Couple' then return(3);
	elseif style=='StepsType_Pump_Halfdouble' then return (1);
	elseif style=='StepsType_Pump_Double' then return (1);
	end;
	
	return 0;
end;

-- Obtiene el digito indicado y lo escribe
function Actor:SetLevelTextByDigit( cur_steps, digit )
	if cur_steps == nil then return; end;
	local style = cur_steps:GetStepsType();
	local description = cur_steps:GetDescription();
	local row = 0;
	local column = 0;
	local meter = cur_steps:GetMeter();
	local chartname = cur_steps:GetChartName();
	local chartcredits = cur_steps:GetAuthorCredit();
	
	if meter>99 then meter = 99; end;
	if meter == 99 then
		column = 10;
	else
		if digit ==1 then
			column = math.floor( (meter/10) );
		elseif digit ==2 then
			column = meter - math.floor( (meter/10) )*10;
		end;
	end;

	if style=='StepsType_Pump_Single' and string.find(description,"SP") then row = 4;
	elseif style=='StepsType_Pump_Single' then row = 0;
	elseif style=='StepsType_Pump_Routine' or (not (string.find(description, "RANDOMSONGS")) and style=='StepsType_Pump_Double' and ((meter == (99 or 50)) or string.find(string.upper(description),"COOP") or string.find(string.upper(description),"CO-OP") or string.find(string.upper(description),"ROUTINE") ) ) then
		row = 6;
		if digit == 1 then 
			column = 12;
		elseif digit == 2 then
			column = 10;
			if string.find(string.upper(description), "2P") or string.find(string.upper(chartname), "2P") or string.find(string.upper(chartcredits), "2 PLAYERS")  or string.find(string.upper(description), "2 P") or string.find(string.upper(chartname), "2 P") or string.find(string.upper(description), "TWO P") or string.find(string.upper(chartname), "TWO P") then column = 2
			elseif string.find(string.upper(description), "3P") or string.find(string.upper(chartname), "3P") or string.find(string.upper(chartcredits), "3 PLAYERS")  or string.find(string.upper(description), "3 P") or string.find(string.upper(chartname), "3 P") or string.find(string.upper(description), "THREE P") or string.find(string.upper(chartname), "THREE P") then column = 3
			elseif string.find(string.upper(description), "4P") or string.find(string.upper(chartname), "4P") or string.find(string.upper(chartcredits), "4 PLAYERS")  or string.find(string.upper(description), "4 P") or string.find(string.upper(chartname), "4 P") or string.find(string.upper(description), "FOUR P") or string.find(string.upper(chartname), "FOUR P") then column = 4
			elseif string.find(string.upper(description), "5P") or string.find(string.upper(chartname), "5P") or string.find(string.upper(chartcredits), "5 PLAYERS")  or string.find(string.upper(description), "5 P") or string.find(string.upper(chartname), "5 P") or string.find(string.upper(description), "FIVE P") or string.find(string.upper(chartname), "FIVE P") then column = 5
			elseif string.find(string.upper(description), "6P") or string.find(string.upper(chartname), "6P") or string.find(string.upper(chartcredits), "6 PLAYERS")  or string.find(string.upper(description), "6 P") or string.find(string.upper(chartname), "6 P") or string.find(string.upper(description), "SIX P") or string.find(string.upper(chartname), "SIX P") then column = 6
			elseif string.find(string.upper(description), "7P") or string.find(string.upper(chartname), "7P") or string.find(string.upper(chartcredits), "7 PLAYERS")  or string.find(string.upper(description), "7 P") or string.find(string.upper(chartname), "7 P") or string.find(string.upper(description), "SEVEN P") or string.find(string.upper(chartname), "SEVEN P") then column = 7
			elseif string.find(string.upper(description), "8P") or string.find(string.upper(chartname), "8P") or string.find(string.upper(chartcredits), "8 PLAYERS")  or string.find(string.upper(description), "8 P") or string.find(string.upper(chartname), "8 P") or string.find(string.upper(description), "EIGHT P") or string.find(string.upper(chartname), "EIGHT P") then column = 8
			elseif string.find(string.upper(description), "9P") or string.find(string.upper(chartname), "9P") or string.find(string.upper(chartcredits), "9 PLAYERS")  or string.find(string.upper(description), "9 P") or string.find(string.upper(chartname), "9 P") or string.find(string.upper(description), "NINE P") or string.find(string.upper(chartname), "NINE P") then column = 9
			elseif string.find(string.upper(description), "1P") or string.find(string.upper(chartname), "1P") or string.find(string.upper(chartcredits), "1 PLAYER")  or string.find(string.upper(description), "1 P") or string.find(string.upper(chartname), "1 P") or string.find(string.upper(description), "ONE P") or string.find(string.upper(chartname), "ONE P") then column = 1
			end;
		end;
	elseif ( style=='StepsType_Pump_Double' and string.find( string.upper(description),"DP" ) ) or style=='StepsType_Pump_Couple' then row = 5;
	elseif style=='StepsType_Pump_Halfdouble' then row = 1;
	elseif style=='StepsType_Pump_Double' then row = 1;
	end
	self:setstate( column + row*13 );
end;

-- Obtiene la etiqueta superior para mostrar en la esfera
local function GetBallLabel(cur_steps)
	local official = IsGroupOfficial();
	if string.find(cur_steps:GetDescription(),"TITLE") then
		return 10
	elseif string.find(cur_steps:GetChartStyle(),"ACTIVE") then
		return 12
	elseif GetLabelNumber(cur_steps:GetLabel() ) == 12 then
		if not official then
			return 5
		else
			return 11
		end;
	else
		return GetLabelNumber( cur_steps:GetLabel() );
	end
end;

-- Obtiene la etiqueta inferior para mostrar en la esfera
local function GetBallUnderLabel( cur_steps )
	local style = cur_steps:GetStepsType();
	local description = cur_steps:GetDescription();
		
		if (style=='StepsType_Pump_Double' and string.find( string.upper(description),"HALFDOUBLE" ) ) or style=='StepsType_Pump_Halfdouble' then return 0;
		elseif (style=='StepsType_Pump_Couple') then return 1;
		end;
		
		return 2; --empty
end;

-- Funci�n para obtener la esfera de nivel
function GetBallLevelText( pn, show_dir_arrows )
	local cur_steps = GAMESTATE:GetCurrentSteps(pn);
	local active_show = 0;
	local chartstyle = "";
	local k = Def.ActorFrame {		
		InitCommand=cmd(basezoom,.67);
		ShowUpCommand=cmd(playcommand,"Update";playcommand,'ShowUpInternal');
		HideCommand=cmd(playcommand,'HideInternal');
		StepsChosenMessageCommand=function(self,params)
			if params.Player == pn then self:playcommand('StepsChosenInternal'); end;
		end;
		ChangeStepsMessageCommand=function(self,params)
			if params.Player ~= pn then return; end;
			self:playcommand('Update');
			self:playcommand('UpdateInternal',{Direction = params.Direction});
			end;
		UpdateCommand=function(self)
			local this = self:GetChildren();
			cur_steps = GAMESTATE:GetCurrentSteps(pn);
			active_show = 0;
			chartstyle = cur_steps:GetChartStyle();
			if string.find(chartstyle,"ACTIVE") then active_show = 1 end;
			
			-- Actualizo color esfera de nivel
			(cmd(stoptweening;diffusealpha,1;setstate,GetDiffNumberBall(cur_steps)))( this.Bigballstitle );			

			-- Actualizo digitos de nivel
			(cmd(stoptweening;diffusealpha,1;SetLevelTextByDigit,cur_steps,1))( this.LevelDigit1 );
			(cmd(stoptweening;diffusealpha,1;SetLevelTextByDigit,cur_steps,2))( this.LevelDigit2 );
			
			-- Actualizo etiquetas
			(cmd(stoptweening;diffusealpha,1;sleep,.03;setstate,GetBallLabel(cur_steps)))( this.Label );
			(cmd(stoptweening;diffusealpha,1;sleep,.03;setstate,GetBallUnderLabel(cur_steps)))( this.Underlabel );
		end;
		children = {						
			LoadActor( THEME:GetPathG("","ScreenSelectMusic/Difficulty_BigBalls_Titles 4x2.png") )..{
				Name="Bigballstitle";
				InitCommand=cmd(pause;zoom,.75);
			};
			
			-- Level (numeros) Digit 1 --
			LoadActor( THEME:GetPathG("","ScreenSelectMusic/Difficulty_Bigballs numbers 13x7.png") )..{
				Name="LevelDigit1";
				InitCommand=cmd(y,5;pause;zoom,.75;x,-25);
			};
			
			-- Level (numeros) Digit 2 --
			LoadActor( THEME:GetPathG("","ScreenSelectMusic/Difficulty_Bigballs numbers 13x7.png") )..{
				Name="LevelDigit2";
				InitCommand=cmd(y,5;pause;x,28;zoom,.75);
			};
			
			-- -- Big glow
			-- LoadActor( THEME:GetPathG("","ScreenSelectMusic/Difficulty_Bigballs bigglow.png") )..{
			-- 	InitCommand=cmd(blend,'BlendMode_Add';diffusealpha,0;visible,show_dir_arrows);
			-- 	OffCommand=cmd(stoptweening;diffusealpha,0;linear,.05;diffusealpha,.5;zoom,1;linear,.2;zoomx,1.5;diffusealpha,0);
			-- };
			
			-- -- Glow Side to side --
			-- LoadActor( THEME:GetPathG("","ScreenSelectMusic/Difficulty_Bigballs glow sidetoside.png") )..{
			-- 	InitCommand=cmd(blend,'BlendMode_Add';diffuse,0,1,1,1);
			-- 	ShowUpInternalCommand=cmd(stoptweening;diffusealpha,0;zoom,1;horizalign,center;x,0;sleep,.2;diffusealpha,1;linear,.2;diffusealpha,0);
			-- 	HideInternalCommand=cmd(stoptweening;diffusealpha,0);
			-- 	OffCommand=cmd(stoptweening;diffusealpha,0);
			-- 	UpdateInternalCommand=function(self,params)
			-- 		if params.Direction == -1 then	--der
			-- 			(cmd(stoptweening;horizalign,left;diffusealpha,0;zoomx,0;x,-55;linear,.1;zoomx,1;diffusealpha,1))(self);
			-- 			(cmd(horizalign,right;diffusealpha,1;zoomx,1;x,55;linear,.1;zoomx,0;diffusealpha,0))(self);
			-- 		elseif params.Direction == 1 then	--izq
			-- 			(cmd(stoptweening;horizalign,right;diffusealpha,0;zoomx,0;x,55;linear,.1;zoomx,1;diffusealpha,1))(self);
			-- 			(cmd(horizalign,left;diffusealpha,1;zoomx,1;x,-55;linear,.1;zoomx,0;diffusealpha,0))(self);
			-- 		end;
			-- 	end;
			-- };
			
			-- Labels --
			LoadActor( THEME:GetPathG("","Common Resources/B_LABELS 1x13.png") )..{
				Name="Label";
				InitCommand=cmd(y,-45;pause;setstate,10; zoom, 0.6);
				--OffCommand=cmd(stoptweening;diffusealpha,1;sleep,.2;linear,.05;diffusealpha,0);
			};
			
			-- Under labels --
			LoadActor( THEME:GetPathG("","Common Resources/B_UNDERLABELS 1x3.png") )..{
				Name="Underlabel";
				InitCommand=cmd(y,40;pause;setstate,2);
				--OffCommand=cmd(stoptweening;diffusealpha,1;sleep,.2;linear,.05;diffusealpha,0);
			};
			
			-- READY? --
			LoadActor( THEME:GetPathG("","ScreenSelectMusic/READY.png") )..{
				InitCommand=cmd(y,60;diffusealpha,0);
				StepsChosenInternalCommand=cmd(stoptweening;diffusealpha,1);
				UpdateInternalCommand=cmd(stoptweening;diffusealpha,0);
				ShowUpInternalCommand=cmd(stoptweening;diffusealpha,0);
				HideInternalCommand=cmd(stoptweening;diffusealpha,0);
				OffCommand=cmd(stoptweening;diffusealpha,0);		
			};
			LoadActor( THEME:GetPathG("","ScreenSelectMusic/READY.png") )..{
				InitCommand=cmd(y,60;blend,'BlendMode_Add';diffusealpha,0);
				StepsChosenInternalCommand=cmd(stoptweening;diffusealpha,1;diffuseshift;effectcolor2,color("1,1,1,.3");effectcolor1,color("1,1,1,0");effectperiod,.2);
				UpdateInternalCommand=cmd(stoptweening;diffusealpha,0);
				ShowUpInternalCommand=cmd(stoptweening;diffusealpha,0);
				HideInternalCommand=cmd(stoptweening;diffusealpha,0);
				OffCommand=cmd(stoptweening;diffusealpha,0);		
			};
		};
	};

	return k;
end;

function GetBallLevelColor( pn, show_dir_arrows )
	local cur_steps = GAMESTATE:GetCurrentSteps(pn);
	local active_show = 0;
	local chartstyle = "";
	local k = Def.ActorFrame {		
		InitCommand=cmd(basezoom,.67);
		ShowUpCommand=cmd(playcommand,"Update";playcommand,'ShowUpInternal');
		HideCommand=cmd(playcommand,'HideInternal');
		StepsChosenMessageCommand=function(self,params)
			if params.Player == pn then self:playcommand('StepsChosenInternal'); end;
		end;
		ChangeStepsMessageCommand=function(self,params)
			if params.Player ~= pn then return; end;
			self:playcommand('Update');
			self:playcommand('UpdateInternal',{Direction = params.Direction});
			end;
		UpdateCommand=function(self)
			local this = self:GetChildren();
			cur_steps = GAMESTATE:GetCurrentSteps(pn);
			active_show = 0;
			chartstyle = cur_steps:GetChartStyle();
			if string.find(chartstyle,"ACTIVE") then active_show = 1 end;
			
			-- Actualizo color esfera de nivel
			(cmd(stoptweening;diffusealpha,1;setstate,GetDiffNumberBall(cur_steps)))( this.Bigballs );			
		end;
		children = {
			

			
			-- Esfera del nivel --
			LoadActor( THEME:GetPathG("","ScreenSelectMusic/Difficulty_Bigballs 4x2.png") )..{
				Name="Bigballs";
				InitCommand=cmd(pause;basezoom,.75);
			};	
			
			-- -- Big glow
			-- LoadActor( THEME:GetPathG("","ScreenSelectMusic/Difficulty_Bigballs bigglow.png") )..{
			-- 	InitCommand=cmd(blend,'BlendMode_Add';diffusealpha,0;visible,show_dir_arrows);
			-- 	OffCommand=cmd(stoptweening;diffusealpha,0;linear,.05;diffusealpha,.5;zoom,1;linear,.2;zoomx,1.5;diffusealpha,0);
			-- };
		};
	};

	return k;
end;


-- Simplified Ball
function GetSimpleBallLevel( pn )
	local l = Def.ActorFrame {		
		InitCommand=cmd(basezoom,.67);
		ShowUpCommand=cmd(playcommand,"Update";playcommand,'ShowUpInternal');
		HideCommand=cmd(playcommand,'HideInternal');
		UpdateCommand=function(self)
			local this = self:GetChildren();
			local cur_steps = GAMESTATE:GetCurrentSteps(pn);
			
			-- Actualizo color esfera de nivel
			(cmd(stoptweening;diffusealpha,1;setstate,GetSimpleDiffNumberBall(cur_steps);basezoom,2))( this.Bigballs );
			
			-- Actualizo digitos de nivel
			(cmd(zoom, .75;stoptweening;diffusealpha,1;SetLevelTextByDigit,cur_steps,1))( this.LevelDigit1 );
			(cmd(zoom, .75;stoptweening;diffusealpha,1;SetLevelTextByDigit,cur_steps,2))( this.LevelDigit2 );
			
		end;
		children = {

			
			-- -- Glow Spin --
			-- LoadActor( THEME:GetPathG("","ScreenSelectMusic/Difficulty_Bigballs glow spin.png") )..{
			-- 	InitCommand=cmd(blend,'BlendMode_Add';diffuse,0,1,1,1);
			-- 	OffCommand=cmd(stoptweening;diffusealpha,0);
			-- 	ShowUpInternalCommand=cmd(stoptweening;diffusealpha,0;sleep,.2;queuecommand,'Spin');
			-- 	UpdateInternalCommand=cmd(stoptweening;queuecommand,'Spin');
			-- 	SpinCommand=cmd(stoptweening;diffusealpha,.8;rotationz,0;linear,.2;rotationz,360;diffusealpha,0);
			-- };
			
			-- LoadActor( THEME:GetPathG("","ScreenSelectMusic/Difficulty_Bigballs glow spin.png") )..{
			-- 	InitCommand=cmd(blend,'BlendMode_Add');
			-- 	OffCommand=cmd(stoptweening;diffusealpha,0);
			-- 	ShowUpInternalCommand=cmd(stoptweening;diffusealpha,0;sleep,.4;queuecommand,'Spin');
			-- 	HideInternalCommand=cmd(stoptweening;diffusealpha,0);
			-- 	SpinCommand=cmd(stoptweening;diffusealpha,.1;rotationz,0;linear,2;rotationz,360;queuecommand,'Spin');
			-- };
			
			-- Esfera del nivel --
			LoadActor( THEME:GetPathG("","ScreenSelectMusic/fullbar balls 7x1.png") )..{
				Name="Bigballs";
				InitCommand=cmd(pause);
			};
			
			-- Level (numeros) Digit 1 --
			LoadActor( THEME:GetPathG("","ScreenSelectMusic/Difficulty_Bigballs numbers 13x7.png") )..{
				Name="LevelDigit1";
				InitCommand=cmd(y,2;pause;x,-22);
			};
			
			-- Level (numeros) Digit 2 --
			LoadActor( THEME:GetPathG("","ScreenSelectMusic/Difficulty_Bigballs numbers 13x7.png") )..{
				Name="LevelDigit2";
				InitCommand=cmd(y,2;pause;x,22);
			};
			
			-- Glow Side to side --
			LoadActor( THEME:GetPathG("","ScreenSelectMusic/Difficulty_Bigballs glow sidetoside.png") )..{
				InitCommand=cmd(blend,'BlendMode_Add';diffuse,0,1,1,1);
				ShowUpInternalCommand=cmd(stoptweening;diffusealpha,0;zoom,1;horizalign,center;x,0;sleep,.2;diffusealpha,1;linear,.2;diffusealpha,0);
				HideInternalCommand=cmd(stoptweening;diffusealpha,0);
				OffCommand=cmd(stoptweening;diffusealpha,0);
				UpdateInternalCommand=function(self,params)
					if params.Direction == -1 then	--der
						(cmd(stoptweening;horizalign,left;diffusealpha,0;zoomx,0;x,-55;linear,.1;zoomx,1;diffusealpha,1))(self);
						(cmd(horizalign,right;diffusealpha,1;zoomx,1;x,55;linear,.1;zoomx,0;diffusealpha,0))(self);
					elseif params.Direction == 1 then	--izq
						(cmd(stoptweening;horizalign,right;diffusealpha,0;zoomx,0;x,55;linear,.1;zoomx,1;diffusealpha,1))(self);
						(cmd(horizalign,left;diffusealpha,1;zoomx,1;x,-55;linear,.1;zoomx,0;diffusealpha,0))(self);
					end;
				end;
			};
		};
	};

	return l;
end;

--/////////////////////////////////////////////////////////////////////////////////////////////////////////////


function FormatTimeLong(totalseconds)
	local hours = math.floor( math.mod(totalseconds, 86400) / 3600 )
	local minutes = math.floor( math.mod(totalseconds, 3600) / 60 )
	local seconds = math.floor( math.mod(totalseconds, 60) )
	if (hours < 10) then
		hours = "0"..hours
	end
	if (minutes < 10) then
		minutes = "0"..minutes
	end
	if (seconds < 10) then
		seconds = "0"..seconds
	end
	return hours..":"..minutes..":"..seconds
end

--

function FormatTime(totalseconds)
	local minutes = math.floor( totalseconds / 60 )
	local seconds = math.floor( math.mod(totalseconds, 60) )
	if (minutes < 10) then
		minutes = "0"..minutes
	end
	if (seconds < 10) then
		seconds = "0"..seconds
	end
	return minutes..":"..seconds
end

--

function IsGroupOfficial()
	local current_group = GAMESTATE:GetCurrentSong():GetGroupName();
	if current_group == "16 - PHOENIX" then
		return true;
	elseif current_group == "01 - 1ST~3RD" then
		return true;
	elseif current_group == "02 - S.E.~EXTRA" then
		return true; 
	elseif current_group == "03 - REBIRTH~PREX 3" then
		return true;
	elseif current_group == "04 - EXCEED~ZERO" then
		return true;
	elseif current_group == "05 - NX~NX2" then
		return true;
	elseif current_group == "06 - NX ABSOLUTE" then
		return true;
	elseif current_group == "07 - PRO~PRO2" then
		return true;
	elseif current_group == "08 - FIESTA" then
		return true;
	elseif current_group == "09 - FIESTA EX" then
		return true;
	elseif current_group == "10 - FIESTA 2" then
		return true;
	elseif current_group == "11 - INFINITY" then
		return true;
	elseif current_group == "12 - PRIME" then
		return true;
	elseif current_group == "13 - PRIME 2" then
		return true;
	elseif current_group == "14 - XX" then
		return true;
	elseif current_group == "15 - MOBILE EDITION" then
		return true;
	else
		return false;
	end
end;