--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

local function OtherPlayer( player )
	if player == 'PlayerNumber_P1' then return 'PlayerNumber_P2'; end;
	if player == 'PlayerNumber_P2' then return 'PlayerNumber_P1'; end;
end;

function GetAvatarFromProfile( player )
	return GAMESTATE:GetAvatarFromProfile( player )
end;

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


function DrawRollingNumberP2(x, y, score, align, delay)
    -- Formatando o número com 7 dígitos
    local score_s = string.format("%07d", score)

    local cur_text = "" -- Texto atual a ser exibido
    local cur_digit = #score_s -- Começa no último dígito
    local zeros = 0 -- Contador de zeros à esquerda

    -- Encontra a quantidade de zeros à esquerda antes do primeiro número não zero
    for i = 1, #score_s do
        if string.sub(score_s, i, i) == "0" then
            zeros = zeros + 1
        else
            break -- Para no primeiro número não zero
        end
    end

    return Def.BitmapText {
        Font = "_plateia 28px",
        OnCommand = function(self)
            self:x(x)
            self:y(y)
            self:horizalign(align)
            self:sleep(delay)
            self:queuecommand("Update")
        end,
        UpdateCommand = function(self)
            -- Adiciona o próximo dígito (da direita para a esquerda)
            cur_text = string.sub(score_s, cur_digit, cur_digit) .. cur_text
            self:settext(cur_text)

            -- Aplica transparência aos zeros à esquerda
            if zeros > 0 and cur_digit <= zeros then
                self:AddAttribute(0, { Diffuse = color("1,1,1,0.3"), Length = zeros })
            end

            -- Reduz o índice para avançar ao próximo dígito
            cur_digit = cur_digit - 1

            -- Para quando todos os dígitos foram exibidos
            if cur_digit == 0 then
                return
            end

            -- Continua a atualização após 0.05 segundos
            self:sleep(0.05)
            self:queuecommand("Update")
        end,
        OffCommand = cmd(stoptweening; visible, false),
    }
end


function DrawRollingNumberP1( x, y, score, horizalign, delay )
local score_s = string.format("%03d",score);
local digits = {};
local len = string.len(score_s);

for i=1,len do
	digits[#digits+1]=string.sub(score_s,i,i);
end;

local cur_text = "";
local cur_text_digits = "";
local cur_digit = 1;
local cur_loop_digit = 0;

return LoadFont("_myriad pro 20px")..{
	OnCommand=function(self)
		self:x(x);
		self:y(y);
		self:horizalign(horizalign);
		self:sleep(delay);
		self:queuecommand('Update');
	end;
	UpdateCommand=function(self)
		
		if( cur_loop_digit == 5 ) then
			cur_loop_digit = 0;
			cur_text_digits = cur_text_digits..digits[cur_digit];
			cur_digit = cur_digit + 1;
			
			if( cur_digit > #digits ) then
				self:settext(cur_text_digits);
				return;
			end;
		end;
		
		cur_text = cur_text_digits..tostring(cur_loop_digit*2+1);
		self:settext(cur_text);
		cur_loop_digit = cur_loop_digit +1;
		
		self:sleep(.04);
		self:queuecommand('Update');
	end;
	OffCommand=cmd(stoptweening;visible,false);
}
end;

-- 





--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////