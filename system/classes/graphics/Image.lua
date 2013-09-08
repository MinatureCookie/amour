--[[
	Class: Image

	Package:
		amour/system/classes/graphics

	Extends:
		<Positionable>

	Description:
		A drawable image element
--]]
return class("Image",
{
	amourPath("system/classes/sceneElements/Positionable")
},
function(Positionable) return {

	inherits = Positionable,

	members = function(self) return {
		
		_image = nil,

		--[[
			Function: init

			Parameters:
				image - A love.graphics image, or a string location of an image file
				x - The original x coordinate of the image
				y - The original y coordinate of the image
		--]]
		init = function(image, x, y)
			if(type(image) == "string") then
				self._image = love.graphics.newImage(image)
			else
				self._image = image
			end

			if(x ~= nil) then
				self._x = x
			end
			if(y ~= nil) then
				self._y = y
			end
		end,

		--[[
			Function: getWidth

			Returns:
				The width of the image
		--]]
		getWidth = function()
			return self._image:getWidth()
		end,
		--[[
			Function: getHeight

			Returns:
				The height of the image
		--]]
		getHeight = function()
			return self._image:getHeight()
		end,

		--[[
			Function: draw

			Descriptions:
				Draws the image at its current coordinate
		--]]
		draw = function()
			love.graphics.draw(self._image, self._x, self._y)
		end

	} end

}end)