function amourPath(currentPath)
	if(currentPath:sub(0, 1) == "/") then
		currentPath = currentPath:sub(1)
	end

	currentPath = AMOUR_ROOT .. currentPath

	return currentPath
end