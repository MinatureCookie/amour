local MessageBus = require(amourPath("system/classes/MessageBus"))

local _messageBus = MessageBus.create()
local _mousePressedIsDown = false

function love.mousepressed(x, y, button)
	if(button == "l" and not(_mousePressedIsDown)) then
		_mousePressedIsDown = true
		_messageBus.sendEventMessage("mousepressed", nil, {["x"] = x, ["y"] = y})
	end
end

function love.mousereleased(x, y, button)
	if(button == "l") then
		_mousePressedIsDown = false
		_messageBus.sendEventMessage("mousereleased", nil, {["x"] = x, ["y"] = y})
	end
end