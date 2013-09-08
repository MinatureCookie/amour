--[[
	Function: requireAll

	Package:
		amour/primitives/requiring

	Description:
		Recursively calls require on all files in the specified directory, and its sub-directories

	Parameters:
		dirs - A string to a directory location, or an object collection of strings to directory locations
--]]
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