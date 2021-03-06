--[[
	Class: ClickableContainer

	Package:
		amour/system/classes/sceneElements

	Extends:
		<PositionableContainer>

	Description:
		A container of elements that will pass on mouse events to any clickables / clickable-containers inside
--]]
return class("ClickableContainer",
{
	amourPath("system/classes/sceneElements/PositionableContainer"),
	amourPath("system/classes/sceneElements/Clickable"),
	amourPath("system/classes/Observer")
},
function(PositionableContainer, Clickable, Observer) return {

	inherits = PositionableContainer,

	members = function(self) return {

		_mouseX = 0,
		_mouseY = 0,
		_observer = Observer.create(),

		--[[
			Function: pollMousePosition

			Description:
				Polls where the mouse position is, and updates accordingly
		--]]
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