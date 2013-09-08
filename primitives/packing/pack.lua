--[[
	Function: pack

	Package:
		amour/primitives/packing

	Description:
		Packs all of the arguments passed to it, into 1 packed object

	Returns:
		A packed object containing all the arguments passed to pack
--]]
function pack(...)
	return {n = select('#', ...), ...}
end