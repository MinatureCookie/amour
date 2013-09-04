return class("ClickableContainer",
{
	"amour/system/classes/sceneElements/PositionableContainer",
	"amour/system/classes/sceneElements/Clickable",
	"amour/system/classes/Observer"
},
function(PositionableContainer, Clickable, Observer) return {

	inherits = PositionableContainer,

	members = function(self) return {

		_mouseX = 0,
		_mouseY = 0,
		_observer = Observer.create(),

		pollMousePosition = function()
			self._mouseX, self._mouseY = love.mouse.getPosition()
			self._positionables.forEach(function(value)
				if(value.isA(self.classValue)) then
					value.pollMousePosition()
				elseif(value.isA(Clickable)) then
					return self._attemptHover(value)
				end
			end)
		end,

		_attemptHover = function(stageItem)
			if(stageItem.isHitBy(self._mouseX, self._mouseY)) then
				self._observer.sendEventMessage("mouseover", stageItem, {x = self._mouseX, y = self._mouseY})
				if(not(stageItem.bubbleFocus)) then
					return false
				end
			else
				self._observer.sendEventMessage("mouseout", stageItem)
			end

			return true
		end

	} end

}end)