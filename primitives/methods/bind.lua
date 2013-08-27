function bind(f, ...)
	local boundVals = pack(...)
	local function newF(...)
		local passedVals = pack(...)

		return f(unpack(mergePacked(boundVals, passedVals)))
	end

	return newF
end