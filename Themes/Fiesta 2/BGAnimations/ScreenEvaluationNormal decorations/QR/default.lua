local player = ...

local ValidScore = LoadActor("ValidScore.lua", player)

local url, text = nil, ""

if ValidScore then
	url = LoadActor("GetURL.lua", player)
	text = ScreenString("QRValidScore")
else
	url = "https://www.youtube.com/watch?v=3WfBTlvsU70"
    text = ScreenString("QRInvalidScore")
end

local qrcode_size = 96

local t = Def.ActorFrame {
    --[[LoadActor( THEME:GetPathG("","ScreenSelectMusic/highscores_bg") )..{
        InitCommand=function(self)
            self:xy(-2, 38)
            self:zoom(0.66)
        end
    };--]]
    
    qrcode_amv( url, qrcode_size )..{
        InitCommand=function(self) 
            self:xy(-50, -50)
            --self:diffusealpha(0.5)
        end,
    }
}

t[#t+1] = LoadActor("x.png")..{
    InitCommand=function(self)
        self:xy(-2, -2)
        self:zoom(0.6)
        self:visible(not ValidScore)
        if not ValidScore then
            self:queuecommand("BlinkX")
        end
    end,
    BlinkXCommand=function(self)
        X_HasBeenBlinked = true
        self:finishtweening()
        self:sleep(0.25)
        self:linear(0.3)
        self:diffusealpha(0.5)
        self:sleep(0.175)
        self:linear(0.3)
        self:diffusealpha(1)
        self:queuecommand("BlinkX")
    end
}

t[#t+1] = LoadFont("_century gothic 20px")..{
	InitCommand=function(self) 
        self:xy(-2, 52)
        self:zoom(0.5)
        self:valign(0)
        self:wrapwidthpixels(192)
        self:settext(text)
    end
};

return t
