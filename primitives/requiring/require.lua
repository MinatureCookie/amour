if(LOADED == nil) then
	LOADED = {}
end

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