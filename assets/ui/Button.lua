return class("Button",
{
	"amour/system/classes/sceneElements/Clickable"
},
function(Clickable) return {

	inherits = Clickable,

	members = function(self) return {

		align = "left",
		color = {255, 255, 255},
		font = love.graphics.newFont("fonts/KBPlanetEarth.ttf", 36),
		x = nil,
		y = nil,
		width = nil,
		callback = nil,

		init = function(value, x, y, width, callback)
			self.super.init()

			self.value = value
			self.callback = callback
			self.x = x
			self.y = y
			self.width = width
		end,

		setAlign = function(align)
			self.align = align
		end,

		setFont = function(font)
			self.font = font
		end,

		setFocus = function()
			self.color = {200, 20, 50}
		end,
		unFocus = function()
			self.color = {255, 255, 255}
		end,

		select = function()
			if(type(self.callback) == "function") then
				self.callback()
			end
		end,

		getWidth = function()
			return self.width
		end,
		getHeight = function()
			return self.font:getHeight()
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

			love.graphics.setColor(self.color)
			love.graphics.setFont(self.font)
			love.graphics.printf(self.value, self.x, self.y, self.width, self.align)

			love.graphics.setColor(oldR, oldG, oldB)
		end

	} end

}end)
