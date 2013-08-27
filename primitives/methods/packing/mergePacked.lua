function mergePacked(...)
	local result = {n = 0}
	for index = 1, select('#', ...) do
		local argAtIndex = select(index, ...)
		for jndex = 1, argAtIndex.n do
			result.n = result.n + 1
			result[result.n] = argAtIndex[jndex]
		end
	end
	return result
end