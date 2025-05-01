local t = Def.ActorFrame {}

if GAMESTATE:IsSideJoined(PLAYER_1) then
    t[#t+1] = GetBallLevelColor(PLAYER_1,true)..{InitCommand=cmd(basezoom,.90;x,cx-124;y,20)};
    t[#t+1] = GetBallLevelText(PLAYER_1,true)..{InitCommand=cmd(basezoom,.90;x,cx-124;y,20);};
end;

if GAMESTATE:IsSideJoined(PLAYER_2) then
    t[#t+1] = GetBallLevelColor(PLAYER_2,true)..{InitCommand=cmd(basezoom,.90;x,cx+124;zoomx,-1;y,20)};
    t[#t+1] = GetBallLevelText(PLAYER_2,true)..{InitCommand=cmd(basezoom,.90;x,cx+124;y,20)};
end;

return t;