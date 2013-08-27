return class("Positionable",
{},
function() return {

	members = function(self) return {

		x = 0,
		y = 0,

		setX = function(x)
			self.x = x
		end,
		setY = function(y)
			self.y = y
		end,

		getWidth = function()
			error("Abstract Positionable class method getWidth call")
		end,
		getHeight = function()
			error("Abstract Positionable class method getHeight call")
		end,

		centerX = function()
			self.setX((love.graphics.getWidth() / 2) - (self.getWidth() / 2))
		end,

		centerY = function()
			self.setY((love.graphics.getHeight() / 2) - (self.getHeight() / 2))
		end,

	} end

}end)