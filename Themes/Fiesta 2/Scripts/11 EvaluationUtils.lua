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

-- Refazer a função de mostrar o Score final, na Phoenix ele já aparece com outra animação, vindo da direita pra esquerda sem o Rolling

--[[function DrawRollingNumberP2( x, y, score, delay )
local score_s = string.format("%07d",score);
local digits = {};
local len = string.len(score_s);

for i=0,(len-1) do
	digits[#digits+1]=string.sub(score_s,len-i,len-i);
end;

local cur_text = "";
local cur_text_digits = "";
local cur_digit = 1;
local cur_loop_digit = 0;

return LoadFont("_plateia 28px")..{
	OnCommand=function(self)
		self:x(x);
		self:y(y);
		self:sleep(delay);
		self:queuecommand('Update');
	end;
	UpdateCommand=function(self)
		
		if( cur_loop_digit == 5 ) then
			cur_loop_digit = 0;
			cur_text_digits = digits[cur_digit]..cur_text_digits;
			cur_digit = cur_digit + 1;
			
			if( cur_digit > #digits ) then
				self:settext(cur_text_digits);
				return;
			end;
		end;
		
		cur_text = tostring(cur_loop_digit*2)..cur_text_digits;
		self:settext(score);
		cur_loop_digit = cur_loop_digit +1;
		
		self:sleep(.10);
		self:queuecommand('Update');
	end;
	OffCommand=cmd(stoptweening;visible,false);
}
end;]]--

--Pedi ajuda pro GPT pra refazer o código com um efeito que fosse parecido com da Phoenix (Da direita pra esquerda)

function DrawRollingNumberP2(x, y, score, align, delay)
    -- Formatando o número com 7 dígitos
    local score_s = string.format("%07d", score)
    -- Separando os dígitos individualmente em uma tabela
    local digits = {}
    for i = 1, #score_s do
        digits[i] = string.sub(score_s, i, i)
    end

    local cur_text = "" -- Texto atual a ser exibido
    local cur_digit = #digits -- Começa no último dígito

    return LoadFont("_plateia 28px") .. {
        OnCommand = function(self)
            self:x(x)
            self:y(y)
			self:horizalign(align)
            self:sleep(delay)
            self:queuecommand("Update")
        end,
        UpdateCommand = function(self)
            -- Adiciona o próximo dígito (da direita para a esquerda)
            cur_text = digits[cur_digit] .. cur_text
            self:settext(cur_text)

            -- Reduz o índice para avançar ao próximo dígito
            cur_digit = cur_digit - 1

            -- Para quando todos os dígitos foram exibidos
            if cur_digit == 0 then
                return
            end

            -- Continua a atualização após 0.5 segundos
            self:sleep(0.05)
            self:queuecommand("Update")
        end,
        OffCommand = cmd(stoptweening; visible, false)
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