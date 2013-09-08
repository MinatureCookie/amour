if(LOADED == nil) then
	LOADED = {}
end

--[[
	Function: require

	Package:
		amour/primitives/requiring

	Description:
		Overrides the default 'require' method to fit with the amour 'unload' method

	Parameters:
		required - The location of the required asset

	Returns:
		Whatever was returned by the required asset
--]]
function require(required)
	if(LOADED[required] ~= nil) then
		print("Already acquired " .. required)
		LOADED[required].count = LOADED[required].count + 1
	else
		print("Requiring " .. required)
		LOADED[required] = {
			count = 1,
			value = love.filesystem.load(required .. ".lua")()
		}
	end

	return LOADED[required].value
end