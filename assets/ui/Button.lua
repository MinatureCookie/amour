--[[
	Class: Button

	Package:
		amour/assets/ui

	Extends:
		<Clickable>

	Description:
		A clickable button, with normal/hover/active states, and callback for onclick
--]]
return class("Button",
{
	amourPath("system/classes/sceneElements/Clickable")
},
function(Clickable) return {

	inherits = Clickable,

	members = function(self) return {

		_align = "left",
		_text = nil,
		_callback = nil,
		_color = nil,
		_colorNormal = {255, 255, 255},
		_colorHover = {230, 20, 0},
		_colorActive = {150, 0, 0},
		_font = love.graphics.newFont(14),
		_callback = nil,
		_parent = nil,

		--[[
			Function: init

			Parameters:
				text - The text of the button
				x - The original x coordinate of the button
				y - The original y coordinate of the button
				width - The original width of the button
				callback - The function to execute when the button is clicked
		--]]
		init = function(text, x, y, width, callback)
			self.super.init()

			self._text = text
			self._callback = callback
			self._x = x
			self._y = y
			self._width = width
			self._color = self._colorNormal
		end,

		--[[
			Function: setParent

			Description:
				Sets an element as the parent of the button, e.g. a ButtonList might be the parent

			Parameters:
				parent - The element to set as the button's parent
		--]]
		setParent = function(parent)
			self._parent = parent
		end,

		--[[
			Function: setAlign

			Parameters:
				align - "left", "center", or "right", how to align the text in the button
		--]]
		setAlign = function(align)
			self._align = align
		end,

		--[[
			Function: setFont

			Parameters:
				font - A love.graphics font (or a string to a font location), the font to use for the button's text
		--]]
		setFont = function(font)
			if(type(font) == "string") then
				self._font = love.graphics.newFont(font, 14)
			else
				self._font = font
			end
		end,

		--[[
			Function: setFocus

			Description:
				Handle the button being set to focus, sets button to hover state
		--]]
		setFocus = function()
			self._color = self._colorHover
		end,
		--[[
			Function: unFocus

			Description:
				Handle the button losing focus, sets button to normal state
		--]]
		unFocus = function()
			self._color = self._colorNormal
		end,
		--[[
			Function: handleMousePressed

			Description:
				Handle the button in process of being clicked (mouse-down, not up), sets button to active state
		--]]
		handleMousePressed = function()
			self._color = self._colorActive
		end,

		--[[
			Function: select

			Description:
				Handle the button being clicked (activates callback)
		--]]
		select = function()
			if(type(self._callback) == "function") then
				self._callback()
			end
		end,

		--[[
			Function: getWidth

			Returns:
				The current width of the button
		--]]
		getWidth = function()
			return self._width
		end,
		--[[
			Function: getHeight

			Returns:
				The current height of the button
		--]]
		getHeight = function()
			return self._font:getHeight()
		end,

		--[[
			Function: getX

			Returns:
				The current x coordinate of the button
		--]]
		getX = function()
			return self._x
		end,
		--[[
			Function: getY

			Returns:
				The current y coordinate of the button
		--]]
		getY = function()
			return self._y
		end,

		--[[
			Function: handleFocus

			Description:
				Handles a focus event, sets its own focus, and alerts parent
		--]]
		handleFocus = function()
			self.setFocus()
			if(self._parent ~= nil) then
				self._parent.handleItemFocus(self)
			end
		end,
		--[[
			Function: handleBlur

			Description:
				Handles a blur event, sets its own focus off
		--]]
		handleBlur = function()
			self.unFocus()
		end,

		--[[
			Function handleClick

			Description:
				Handles a click event, selects itself
		--]]
		handleClick = function()
			self.select()
		end,

		--[[
			Function: draw

			Description:
				Draws the button with its current properties
		--]]
		draw = function()
			local oldR, oldG, oldB = love.graphics.getColor()
			local oldFont = love.graphics.getFont()

			love.graphics.setColor(self._color)
			love.graphics.setFont(self._font)

			love.graphics.printf(self._text, self._x, self._y, self._width, self._align)

			love.graphics.setColor(oldR, oldG, oldB)
			love.graphics.setFont(oldFont)
		end

	} end

}end)
