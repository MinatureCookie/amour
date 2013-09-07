return class("Image",
{
	amourPath("system/classes/sceneElements/Positionable")
},
function(Positionable) return {

	inherits = Positionable,

	members = function(self) return {
		
		_image = nil,

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

		getWidth = function()
			return self._image:getWidth()
		end,
		getHeight = function()
			return self._image:getHeight()
		end,

		draw = function()
			love.graphics.draw(self._image, self._x, self._y)
		end

	} end

}end)