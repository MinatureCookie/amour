--[[
	Class: Clickable

	Package:
		amour/system/classes/sceneElements

	Extends:
		<Positionable>

	Description:
		A clickable element, giving hover/blur/click events
--]]
return class("Clickable",
{
	amourPath("system/classes/Observer"),
	amourPath("system/classes/sceneElements/Positionable")
},
function(Observer, Positionable) return {

	inherits = Positionable,

	members = function(self) return {

		_observer = Observer.create(),

		--[[
			Function: init
		--]]
		init = function()
			self._observer.addEventListener("mousepressed", self._handleMousePressedSomewhere)
			self._observer.addEventListener("mouseover", self._handleMouseOver, self)
		end,

		--[[
			Function: isHitBy

			Description:
				Determines whether a given coordinate is within the bounding box of the element

			Parameters:
				x - The x coordinate we are testing
				y - The y coordinate we are testing

			Returns:
				A boolean, true iff the coordinate is within the element's bounding box
		--]]
		isHitBy = function(x, y)
			return (x < self._x + self.getWidth()
					and x > self._x
					and y < self._y + self.getHeight()
					and y > self._y)
		end,

		--[[
			Function: handleClick

			Description:
				Is called whenever the element is clicked
		--]]
		handleClick = function()
		end,

		--[[
			Function: handleMousePressed

			Description:
				Is called whenever the element has the mouse button clicked down on it
		--]]
		handleMousePressed = function()
		end,

		--[[
			Function: handleMouseReleased

			Description:
				Is called whenever the element has the mouse button released on it
		--]]
		handleMouseReleased = function()
		end,

		--[[
			Function: handleFocus

			Description:
				Is called whenever the element has the mouse hover over it
		--]]
		handleFocus = function()
		end,

		--[[
			Function: handleBlur

			Description:
				Is called whenever the element loses mouse focus
		--]]
		handleBlur = function()
		end,

		--[[
			Function: destroy

			Description:
				Prepares the element for destruction (removing clicking listeners)
		--]]
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