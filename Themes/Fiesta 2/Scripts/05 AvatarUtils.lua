--/////////////////////////////////////////////////////////////////////////////////////////////////////////
--/////////////////////////////////////////////////////////////////////////////////////////////////////////
local LocalProfPath = "Save/LocalProfiles/"

-- index empieza desde cero
function ReadAvatarID( index )
	local numLP = PROFILEMAN:GetNumLocalProfiles();
	if (index+1) > numLP then return nil; end;
	
	local charID = PROFILEMAN:GetLocalProfileFromIndex( index ):GetAvatarID();
	return charID;
end

function WriteAvatarID(index,value)
	local numLP = PROFILEMAN:GetNumLocalProfiles();
	if (index+1) > numLP then return nil; end;
	
	PROFILEMAN:GetLocalProfileFromIndex( index ):SetAvatarID( value );
	local profID = PROFILEMAN:GetLocalProfileIDFromIndex( index );
	PROFILEMAN:SaveLocalProfile( profID );
end

--/////////////////////////////////////////////////////////////////////////////////////////////////////////
--/////////////////////////////////////////////////////////////////////////////////////////////////////////
-- code by xMAx