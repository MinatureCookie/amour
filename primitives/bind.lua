--[[
	Function: bind

	Package:
		amour/primitives

	Description:
		Curries a function

	Parameters:
		f - The function to curry
		... - The arguments to curry with f so far

	Returns:
		A new curried function, awaiting the remainder of its arguments
--]]
function bind(f, ...)
	local boundVals = pack(...)
	local function newF(...)
		local passedVals = pack(...)

		return f(unpack(mergePacked(boundVals, passedVals)))
	end

	return newF
end