--[[
	Class: Positionable

	Package:
		amour/system/classes/sceneElements

	Description:
		A positionable element that can be drawn, and added to the stage
--]]
return class("Positionable",
{},
function() return {

	members = function(self) return {

		_x = 0,
		_y = 0,

		--[[
			Function: setX

			Parameters:
				x - The new x coordinate of the element
		--]]
		setX = function(x)
			self._x = x
		end,
		--[[
			Function: setY

			Parameters:
				y - The new y coordinate of the element
		--]]
		setY = function(y)
			self._y = y
		end,

		--[[
			Function: getWidth

			Abstract:
				true

			Returns:
				The current width of the element
		--]]
		getWidth = function()
			error("Abstract Positionable class method getWidth call")
		end,
		--[[
			Function: getHeight

			Abstract:
				true

			Description:
				The current height of the element
		--]]
		getHeight = function()
			error("Abstract Positionable class method getHeight call")
		end,

		--[[
			Function: centerX

			Description:
				Centers the current element, along the x-axis
		--]]
		centerX = function()
			self.setX((love.graphics.getWidth() / 2) - (self.getWidth() / 2))
		end,

		--[[
			Function: centerY

			Description:
				Centers the current element, along the y-axis
		--]]
		centerY = function()
			self.setY((love.graphics.getHeight() / 2) - (self.getHeight() / 2))
		end,

	} end

}end)