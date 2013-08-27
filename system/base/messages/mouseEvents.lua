local MessageBus = require("amour/system/classes/MessageBus")
local Clickable = require("amour/system/classes/sceneElements/Clickable")

local messageBus = MessageBus.create()
local mousePressedIsDown = false
local mouseX = 0
local mouseY = 0

local function _attemptHover(stageItem)
	if(stageItem.isHitBy(mouseX, mouseY)) then
		messageBus.sendEventMessage("mouseover", stageItem, {x = mouseX, y = mouseY})
		if(not(stageItem.bubbleFocus)) then
			return false
		end
	else
		messageBus.sendEventMessage("mouseout", stageItem)
	end

	return true
end

function pollMousePosition()
	mouseX, mouseY = love.mouse.getPosition()
	if(stage) then
		stage.forEach(function(value)
			if(value.isA(Clickable)) then
				return _attemptHover(value)
			end
		end)
	end
end

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