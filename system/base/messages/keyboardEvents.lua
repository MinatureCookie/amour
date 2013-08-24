require("amour/system/classes/MessageBus")

messageBus = MessageBus.create()

keyMap = {
	["up"] = "up",
	["w"] = "up",
	["z"] = "up",
	["down"] = "down",
	["s"] = "down",
	["x"] = "down",

	["return"] = "enter"
}

function love.keypressed(key, unicode)
	messageBus.sendEventMessage("keypressed", nil, {["key"] = keyMap[key], ["unicode"] = unicode})
end

function love.keyreleased(key, unicode)
	messageBus.sendEventMessage("keyreleased", nil, {["key"] = keyMap[key], ["unicode"] = unicode})
end