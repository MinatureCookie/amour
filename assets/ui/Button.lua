return class("Button",
{
	amourPath("system/classes/sceneElements/Clickable")
},
function(Clickable) return {

	inherits = Clickable,

	members = function(self) return {

		_align = "left",
		_color = nil,
		_colorNormal = {255, 255, 255},
		_colorHover = {230, 20, 0},
		_colorActive = {150, 0, 0},
		_font = love.graphics.newFont(14),
		_callback = nil,

		init = function(value, x, y, width, callback)
			self.super.init()

			self._value = value
			self._callback = callback
			self._x = x
			self._y = y
			self._width = width
			self._color = self._colorNormal
		end,

		setAlign = function(align)
			self._align = align
		end,

		setFont = function(font)
			self._font = font
		end,

		setFocus = function()
			self._color = self._colorHover
		end,
		unFocus = function()
			self._color = self._colorNormal
		end,
		handleMousePressed = function()
			self._color = self._colorActive
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
			local oldFont = love.graphics.getFont()

			love.graphics.setColor(self._color)
			love.graphics.setFont(self._font)

			love.graphics.printf(self._value, self._x, self._y, self._width, self._align)

			love.graphics.setColor(oldR, oldG, oldB)
			love.graphics.setFont(oldFont)
		end

	} end

}end)
