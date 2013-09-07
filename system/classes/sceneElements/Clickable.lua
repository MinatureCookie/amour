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
			self._observer.addEventListener("mousepressed", self._handleMousePressedSomewhere)
			self._observer.addEventListener("mouseover", self._handleMouseOver, self)
		end,

		isHitBy = function(x, y)
			return (x < self._x + self.getWidth()
					and x > self._x
					and y < self._y + self.getHeight()
					and y > self._y)
		end,

		handleClick = function()
		end,

		handleMousePressed = function()
		end,

		handleMouseReleased = function()
		end,

		handleFocus = function()
		end,

		handleBlur = function()
		end,

		destroy = function()
			self._observer.removeEventListener("mousepressed", self._handleMousePressedSomewhere)
		end,

		_handleMouseOver = function()
			self._observer.removeEventListener("mouseover", self._handleMouseOver, self)
			self._observer.addEventListener("mouseout", self._handleMouseOut, self)

			self.handleFocus()
		end,

		_handleMouseOut = function()
			self._observer.addEventListener("mouseover", self._handleMouseOver, self)
			self._observer.removeEventListener("mouseout", self._handleMouseOut, self)

			self.handleBlur()
		end,

		_handleMousePressedSomewhere = function(data)
			if(self.isHitBy(data["x"], data["y"])) then
				self.handleMousePressed()
				self._observer.addEventListener("mousereleased", self._handleMouseReleasedSomewhere)
			end
		end,

		_handleMouseReleasedSomewhere = function(data)
			self._observer.removeEventListener("mousereleased", self._handleMouseReleasedSomewhere)
			if(self.isHitBy(data["x"], data["y"])) then
				self.handleMouseReleased()
				self.handleClick()
			end
		end

	} end

} end)