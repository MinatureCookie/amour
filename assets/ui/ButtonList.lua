return class("ButtonList",
{
	amourPath("system/classes/Observer"),
	amourPath("system/classes/sceneElements/ClickableContainer"),
	amourPath("assets/ui/Button")
},
function(Observer, ClickableContainer, Button) return {

	inherits = ClickableContainer,

	members = function(self) return {

		observer = Observer.create(),

		padding = 0,
		focus = false,
		currentFocus = 1,

		init = function(x, y, width)
			self.super.init()

			self.x = x
			self.y = y
			self.width = width

			self.observer.addEventListener("keypressed", self._handleKeyPress)
		end,

		_handleUpPress = function()
			if(self.focus) then
				self._positionables.get(self.currentFocus).unFocus()

				if(self.currentFocus > 1) then
					self.currentFocus = self.currentFocus - 1
				end

				self._positionables.get(self.currentFocus).setFocus()
			end
		end,

		_handleDownPress = function()
			if(self.focus) then
				self._positionables.get(self.currentFocus).unFocus()

				if(self.currentFocus < self._positionables.length) then
					self.currentFocus = self.currentFocus + 1
				end

				self._positionables.get(self.currentFocus).setFocus()
			end
		end,

		_handleEnterPress = function()
			if(self.focus) then
				self._positionables.get(self.currentFocus).select()
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
		end,

		setAlign = function(align)
			self.align = align
		end,

		setPadding = function(padding)
			self.padding = padding
		end,

		setFont = function(font)
			self.font = font
		end,

		setY = function(y)
			local dif = self.y - y
			self.y = y

			self._positionables.forEach(function(button)
				button.setY(button.y - dif)
			end)
		end,

		getWidth = function()
			return self.width
		end,
		getHeight = function()
			local countedHeight = 0
			self._positionables.forEach(function(button)
				countedHeight = countedHeight + button.getHeight()
			end)

			return countedHeight
		end,

		setFocus = function()
			if(self._positionables.length ~= 0) then
				self.focus = true
				(self._positionables.get(self.currentFocus)).setFocus()
			end
		end,
		unFocus = function()
			self.focus = false
		end,

		addNew = function(text, callback, font)
			local newY = self.y
			local last = self._positionables.last()
			if(last ~= nil) then
				newY = last.y + last.getHeight() + self.padding
			end

			if(font == nil) then
				font = self.font
			end

			local newButton = Button.create(text, self.x, newY, self.width, callback)
			newButton.setFont(font)
			newButton.setAlign(self.align)

			self.super.addNew(newButton)
		end,

		destroy = function()
			self.observer.removeEventListener("keypressed", self._handleKeyPress)

			self.super.destroy()
		end

	} end

}end)