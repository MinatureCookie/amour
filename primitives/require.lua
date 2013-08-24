if(_love2dRequire == nil) then
	_love2dRequire = require
	_LOADED = {}
end

function require(required)
	_LOADED[required] = true

	_love2dRequire(required)
end