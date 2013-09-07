return class("Button",
{
	amourPath("system/classes/sceneElements/Clickable")
},
function(Clickable) return {

	inherits = Clickable,

	members = function(self) return {

		_align = "left",
		_color = {255, 255, 255},
		_font = love.graphics.newFont("fonts/KBPlanetEarth.ttf", 36),
		_callback = nil,

		init = function(value, x, y, width, callback)
			self.super.init()

			self._value = value
			self._callback = callback
			self._x = x
			self._y = y
			self._width = width
		end,

		setAlign = function(align)
			self._align = align
		end,

		setFont = function(font)
			self._font = font
		end,

		setFocus = function()
			self._color = {200, 20, 50}
		end,
		unFocus = function()
			self._color = {255, 255, 255}
		end,

		select = function()
			if(type(self._callback) == "function") then
				self._callback()
			end
		end,

		getWidth = function()
			return self._width
		end,
		getHeight = function()
			return self._font:getHeight()
		end,

		getX = function()
			return self._x
		end,
		getY = function()
			return self._y
		end,

		handleFocus = function()
			self.setFocus()
		end,
		handleBlur = function()
			self.unFocus()
		end,

		handleClick = function()
			self.select()
		end,

		draw = function()
			local oldR, oldG, oldB = love.graphics.getColor()

			love.graphics.setColor(self._color)
			love.graphics.setFont(self._font)
			love.graphics.printf(self._value, self._x, self._y, self._width, self._align)

			love.graphics.setColor(oldR, oldG, oldB)
		end

	} end

}end)
