require("amour/system/classes/Observer")
require("amour/system/classes/sceneElements/Positionable")

Clickable = class(Positionable)(function(self)return{

	observer = Observer.create(),

	init = function()
		self.observer.addEventListener("mousepressed", self.handleMousePressed)
		self.observer.addEventListener("mouseover", self.handleMouseOver, self)
	end,

	isHitBy = function(x, y)
		return (x < self.x + self.getWidth()
			and x > self.x
			and y < self.y + self.getHeight()
			and y > self.y)
	end,

	handleMouseOver = function()
		self.observer.removeEventListener("mouseover", self.handleMouseOver, self)
		self.observer.addEventListener("mouseout", self.handleMouseOut, self)

		self.handleFocus()
	end,

	handleMouseOut = function()
		self.observer.addEventListener("mouseover", self.handleMouseOver, self)
		self.observer.removeEventListener("mouseout", self.handleMouseOut, self)

		self.handleBlur()
	end,

	handleMousePressed = function(data)
		if(self.isHitBy(data["x"], data["y"])) then
			self.observer.addEventListener("mousereleased", self.handleMouseReleased)
		end
	end,

	handleMouseReleased = function(data)
		self.observer.removeEventListener("mousereleased", self.handleMouseReleased)
		if(self.isHitBy(data["x"], data["y"])) then
			self.handleClick()
		end
	end,

	handleClick = function()
	end,

	handleFocus = function()
	end,

	handleBlur = function()
	end,

	destroy = function()
		self.observer.removeEventListener("mousepressed", self.handleMousePressed)
	end

}end)