local MessageBus = require(amourPath("system/classes/MessageBus"))

local _messageBus = MessageBus.create()

local _keyMap = {
	["up"] = "up",
	["w"] = "up",
	["z"] = "up",
	["down"] = "down",
	["s"] = "down",
	["x"] = "down",
	["right"] = "right",
	["d"] = "right",
	["left"] = "left",
	["a"] = "left",

	["return"] = "return"
}

function love.keypressed(key, unicode)
	_messageBus.sendEventMessage("keypressed", nil, {["key"] = _keyMap[key], ["unicode"] = unicode})
end

function love.keyreleased(key, unicode)
	_messageBus.sendEventMessage("keyreleased", nil, {["key"] = _keyMap[key], ["unicode"] = unicode})
end