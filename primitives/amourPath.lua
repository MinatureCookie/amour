--[[
	Function: amourPath

	Package:
		amour/primitives

	Description:
		Converts a path to AMOUR_ROOT+path, to allow for relative amour directory placing

	Parameters:
		currentPath - The path relative to the amour directory

	Returns:
		A static path to the amour directory/file provided
--]]
function amourPath(currentPath)
	if(currentPath:sub(0, 1) == "/") then
		currentPath = currentPath:sub(1)
	end

	currentPath = AMOUR_ROOT .. currentPath

	return currentPath
end