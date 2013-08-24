require("amour/system/classes/MessageBus")
require("amour/system/classes/sceneElements/Clickable")

messageBus = MessageBus.create()
mousePressedIsDown = false
mouseX = 0
mouseY = 0

function _attemptHover(stageItem)
	if(stageItem.isHitBy(mouseX, mouseY)) then
		messageBus.sendEventMessage("mouseover", stageItem)
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
				print("Yeah")
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