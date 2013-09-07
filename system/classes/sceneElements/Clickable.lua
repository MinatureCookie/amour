return class("Clickable",
{
	amourPath("system/classes/Observer"),
	amourPath("system/classes/sceneElements/Positionable")
},
function(Observer, Positionable) return {

	inherits = Positionable,

	members = function(self) return {

		_observer = Observer.create(),

		init = function()
			self._observer.addEventListener("mousepressed", self.handleMousePressed)
			self._observer.addEventListener("mouseover", self.handleMouseOver, self)
		end,

		isHitBy = function(x, y)
			return (x < self._x + self.getWidth()
					and x > self._x
					and y < self._y + self.getHeight()
					and y > self._y)
		end,

		handleMouseOver = function()
			self._observer.removeEventListener("mouseover", self.handleMouseOver, self)
			self._observer.addEventListener("mouseout", self.handleMouseOut, self)

			self.handleFocus()
		end,

		handleMouseOut = function()
			self._observer.addEventListener("mouseover", self.handleMouseOver, self)
			self._observer.removeEventListener("mouseout", self.handleMouseOut, self)

			self.handleBlur()
		end,

		handleMousePressed = function(data)
			if(self.isHitBy(data["x"], data["y"])) then
				self._observer.addEventListener("mousereleased", self.handleMouseReleased)
			end
		end,

		handleMouseReleased = function(data)
			self._observer.removeEventListener("mousereleased", self.handleMouseReleased)
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
			self._observer.removeEventListener("mousepressed", self.handleMousePressed)
		end

	} end

} end)