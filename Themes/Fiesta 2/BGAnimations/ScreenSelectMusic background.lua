local t = Def.ActorFrame {};

local gameMode = GAMESTATE:Env()["SelectedGameMode"]

if gameMode == "Keyboard" then
t[#t+1] = LoadActor( BGDirB.."/ARCADE_BG" )..{
--t[#t+1] = LoadActor( "ad.png" )..{
	OnCommand=function(self)
		self:Center()
		self:show_background_properly()
		self:loop(true)
		self:diffusecolor(0.7,0.7,0.7,1)
		local cur_group = SCREENMAN:GetTopScreen():GetCurrentGroup();
	
		if ( cur_group == "SO_QUEST" or cur_group == "04-SKILLUP ZONE" ) then
			self:visible(false);
			self:pause();
		else
			self:play();
		end;
	end;
	ShowGreenStuffsMessageCommand=cmd(stoptweening;visible,false;pause);
	HideGreenStuffsMessageCommand=cmd(stoptweening;visible,true;play);
}
elseif gameMode == "PumpPad" then
	t[#t+1] = LoadActor( BGDirB.."/ARCADE_BG" )..{
--t[#t+1] = LoadActor( "ad.png" )..{
	OnCommand=function(self)
		self:Center()
		self:show_background_properly()
		self:loop(true)
		self:diffusebottomedge(color("1,0,0,1"))
		self:diffusetopedge(color("1,0.5,0.5,1"))
		local cur_group = SCREENMAN:GetTopScreen():GetCurrentGroup();
		
		if ( cur_group == "SO_QUEST" or cur_group == "04-SKILLUP ZONE" ) then
			self:visible(false);
			self:pause();
		else
			self:play();
		end;
	end;
	ShowGreenStuffsMessageCommand=cmd(stoptweening;visible,false;pause);
	HideGreenStuffsMessageCommand=cmd(stoptweening;visible,true;play);
}
end



t[#t+1] = LoadActor( BGDirB.."/MISSION_BG" )..{
	OnCommand=function(self)
		(cmd(Center;show_background_properly;loop,true))(self)
		local cur_group = SCREENMAN:GetTopScreen():GetCurrentGroup();
		
		if not ( cur_group == "SO_QUEST" or cur_group == "04-SKILLUP ZONE" ) then
			self:visible(false);
			self:pause();
		else
			self:play();
		end;
	end;
	ShowGreenStuffsMessageCommand=cmd(stoptweening;visible,true;play);
	HideGreenStuffsMessageCommand=cmd(stoptweening;visible,false;pause);
}

return t;