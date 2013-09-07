function unload(unrequired)
	local success = true

	if(LOADED[unrequired] ~= nil) then
		if(LOADED[unrequired].count == 1) then
			print("Unloading " .. unrequired)
			LOADED[unrequired] = nil
		else
			print("Preparing to unload " .. unrequired .. " (it is required elsewhere, still)")
			LOADED[unrequired].count = LOADED[unrequired].count - 1
		end
	else
		print(unrequired .. " was never acquired! Cannot unload")
		success = false
	end

	return success
end