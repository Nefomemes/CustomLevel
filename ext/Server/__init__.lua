local XP2_SkybarJSON = require "testpreset"
local MP_013JSON = require "MP_013"

local XP2_Skybar = json.decode(XP2_SkybarJSON)
local MP_013 = json.decode(MP_013JSON)


local dic = {
	["Levels/XP2_Skybar/XP2_Skybar"] = XP2_Skybar,
	["Levels/MP_013/MP_013"] = MP_013
}

local function DecodeParams(p_Table)
    if(p_Table == nil) then
        print("No table received")
        return false
	end
	for s_Key, s_Value in pairs(p_Table) do
		if s_Key == 'transform' or s_Key == 'localTransform'then
			local s_LinearTransform = LinearTransform(
					Vec3(s_Value.left.x, s_Value.left.y, s_Value.left.z),
					Vec3(s_Value.up.x, s_Value.up.y, s_Value.up.z),
					Vec3(s_Value.forward.x, s_Value.forward.y, s_Value.forward.z),
					Vec3(s_Value.trans.x, s_Value.trans.y, s_Value.trans.z))

			p_Table[s_Key] = s_LinearTransform

		elseif type(s_Value) == "table" then
			p_Table[s_Key] = DecodeParams(s_Value)
		end

	end

	return p_Table
end

Events:Subscribe('Level:LoadResources', function()
	local levelName = SharedUtils:GetLevelName()
	print(levelName)
	local preset = dic[levelName]
	if preset == nil then
		print("Empty map dictionary: no custom map data for map: " .. levelName)
		return
	end
	Events:Dispatch('MapLoader:LoadLevel', preset)
end)