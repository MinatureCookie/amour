function requireAll(dirs)
	if(type(dirs) == "string") then
		dirs = {dirs}
	end

	for index, dir in pairs(dirs) do
		local filesTable = love.filesystem.enumerate(dir)
		for jndex, value in ipairs(filesTable) do
			local current = dir .. "/" .. value
			if(love.filesystem.isFile(current)) then
				require(current:sub(0, -5))
			elseif(love.filesystem.isDirectory(current)) then
				requireAll(current)
			end
		end
	end
end