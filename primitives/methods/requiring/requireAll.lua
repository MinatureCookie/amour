function requireAll(dir)
	local filesTable = love.filesystem.enumerate(dir)
	for index, value in ipairs(filesTable) do
		local current = dir .. "/" .. value
		if(love.filesystem.isFile(current)) then
			require(current:sub(0, -5))
		elseif(love.filesystem.isDirectory(current)) then
			requireAll(current)
		end
	end
end