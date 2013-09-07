return class("ButtonList",
{
	amourPath("system/classes/Observer"),
	amourPath("system/classes/sceneElements/ClickableContainer"),
	amourPath("assets/ui/Button")
},
function(Observer, ClickableContainer, Button) return {

	inherits = ClickableContainer,

	members = function(self) return {

		_padding = 0,
		_focus = false,
		_currentFocus = 1,
		_width = nil,
		_font = love.graphics.newFont(14),

		init = function(x, y, width)
			self.super.init()

			self._x = x
			self._y = y
			self._width = width

			self._observer.addEventListener("keypressed", self._handleKeyPress)
		end,

		setAlign = function(align)
			self._align = align
		end,

		setPadding = function(padding)
			self._padding = padding
		end,

		setFont = function(font)
			self._font = font
		end,

		setY = function(y)
			local dif = self._y - y
			self._y = y

			self._positionables.forEach(function(button)
				button.setY(button.getY() - dif)
			end)
		end,

		getWidth = function()
			return self._width
		end,
		getHeight = function()
			local countedHeight = 0
			self._positionables.forEach(function(button)
				countedHeight = countedHeight + button.getHeight()
			end)

			return countedHeight
		end,

		setFocus = function()
			if(self._positionables.length() ~= 0) then
				self._focus = true
				(self._positionables.get(self._currentFocus)).setFocus()
			end
		end,
		unFocus = function()
			self._focus = false
		end,

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
			elseif(data.key == "enter") then
				self._handleEnterPress()
			end
		end

	} end

}end)