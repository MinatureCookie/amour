local MessageBus = require("amour/system/classes/MessageBus")
local Clickable = require("amour/system/classes/sceneElements/Clickable")

local messageBus = MessageBus.create()
local mousePressedIsDown = false

function love.mousepressed(x, y, button)
	if(button == "l" and not(mousePressedIsDown)) then
		mousePressedIsDown = true
		messageBus.sendEventMessage("mousepressed", nil, {["x"] = x, ["y"] = y})
	end
end

function love.mousereleased(x, y, button)
	if(button == "l") then
		mousePressedIsDown = false
		messageBus.sendEventMessage("mousereleased", nil, {["x"] = x, ["y"] = y})
	end
end