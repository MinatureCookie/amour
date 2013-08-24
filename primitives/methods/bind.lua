function _bindPackn(...)
	return {n = select('#', ...), ...}
end

function _bindUnpackn(t)
	return (table.unpack or unpack)(t, 1, t.n)
end

function _bindMergen(...)
	local res = {n=0}
	for i = 1, select('#', ...) do
		local t = select(i, ...)
		for j = 1, t.n do
			res.n = res.n + 1
			res[res.n] = t[j]
		end
	end
	return res
end

function bind(f, ...)
	local boundVals = _bindPackn(...)
	local function newF(...)
		local passedVals = _bindPackn(...)

		return f(_bindUnpackn(_bindMergen(boundVals, passedVals)))
	end

	return newF
end