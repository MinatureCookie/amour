--[[
	Class: ButtonList

	Package:
		amour/assets/ui

	Extends:
		<ClickableContainer>


	Description:
		A vertical list of Button assets

	See Also:
		<Button>
--]]
return class("ButtonList",
{
	amourPath("system/classes/sceneElements/ClickableContainer"),
	amourPath("assets/ui/Button")
},
function(ClickableContainer, Button) return {

	inherits = ClickableContainer,

	members = function(self) return {

		_padding = 0,
		_focus = false,
		_currentFocus = 1,
		_width = nil,
		_font = love.graphics.newFont(14),

		--[[
			Function: init

			Parameters:
				x - The original x coordinate of the button list
				y - The original y coordinate of the button list
				width - The original width of the button list
		--]]
		init = function(x, y, width)
			self.super.init()

			self._x = x
			self._y = y
			self._width = width

			self._observer.addEventListener("keypressed", self._handleKeyPress)
		end,

		--[[
			Function: setAlign

			Parameters:
				align - "left", "center", or "right", how to align the buttons within the button list
		--]]
		setAlign = function(align)
			self._align = align
		end,

		--[[
			Function: setPadding

			Parameters:
				padding - How many pixels to pad between each button in the button list
		--]]
		setPadding = function(padding)
			self._padding = padding
		end,

		--[[
			Function: setFont

			Parameters:
				font - A love.graphics font (or a string location of a font), to set as the buttons' font
		--]]
		setFont = function(font)
			self._font = font
		end,

		--[[
			Function: setY

			Parameters:
				y - The new y coordinate of the button list
		--]]
		setY = function(y)
			local dif = self._y - y
			self._y = y

			self._positionables.forEach(function(button)
				button.setY(button.getY() - dif)
			end)
		end,

		--[[
			Function: getWidth

			Returns:
				The current width of the button list
		--]]
		getWidth = function()
			return self._width
		end,
		--[[
			Function: getHeight

			Returns:
				The current height of the button list
		--]]
		getHeight = function()
			local countedHeight = 0
			self._positionables.forEach(function(button)
				countedHeight = countedHeight + button.getHeight()
			end)

			return countedHeight
		end,

		--[[
			Function: setFocus

			Description:
				Sets the button list as in focus, allowing its navigation and use
		--]]
		setFocus = function()
			if(self._positionables.length() ~= 0) then
				self._focus = true
				(self._positionables.get(self._currentFocus)).setFocus()
			end
		end,
		--[[
			Function: unFocus

			Description:
				Sets the button list as out of focus, disabling its navigation and use
		--]]
		unFocus = function()
			self._focus = false
		end,

		--[[
			Function: addNew

			Description:
				Adds a new button to the button list, auto-positioned to the correct place

			Parameters:
				text - The text to set the new button with
				callback - The callback method for the button's click event
				font - A custom font for this particular button (leave nil to inherit from button list)
		--]]
		addNew = function(text, callback, font)
			local newY = self._y
			local last = self._positionables.last()
			if(last ~= nil) then
				newY = last.getY() + last.getHeight() + self._padding
			end

			if(font == nil) then
				font = self._font
			end

			local newButton = Button.create(text, self._x, newY, self._width, callback)
			newButton.setFont(font)
			newButton.setAlign(self._align)
			newButton.setParent(self)

			self.super.addNew(newButton)
		end,

		--[[
			Function: handleItemFocus

			Description:
				Handles what to do if a sub element has focused itself beyond the button list's knowledge

			Parameters:
				item - The button in the button list that has focused itself
		--]]
		handleItemFocus = function(item)
			self._positionables.forEach(function(button, index)
				if(button == item) then
					self._currentFocus = index
					button.setFocus()
				else
					button.unFocus()
				end
			end)
		end,

		--[[
			Function: destroy

			Description:
				Prepares the button list for destruction
		--]]
		destroy = function()
			self._observer.removeEventListener("keypressed", self._handleKeyPress)

			self.super.destroy()
		end,

		_handleUpPress = function()
			if(self._focus) then
				self._positionables.get(self._currentFocus).unFocus()

				if(self._currentFocus > 1) then
					self._currentFocus = self._currentFocus - 1
				end

				self._positionables.get(self._currentFocus).setFocus()
			end
		end,

		_handleDownPress = function()
			if(self._focus) then
				self._positionables.get(self._currentFocus).unFocus()

				if(self._currentFocus < self._positionables.length()) then
					self._currentFocus = self._currentFocus + 1
				end

				self._positionables.get(self._currentFocus).setFocus()
			end
		end,

		_handleEnterPress = function()
			if(self._focus) then
				self._positionables.get(self._currentFocus).select()
			end
		end,

		_handleKeyPress = function(data)
			if(data.key == "up") then
				self._handleUpPress()
			elseif(data.key == "down") then
				self._handleDownPress()
			elseif(data.key == "return") then
				self._handleEnterPress()
			end
		end

	} end

}end)