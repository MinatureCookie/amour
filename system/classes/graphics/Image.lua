return class("Image",
{
	amourPath("system/classes/sceneElements/Positionable")
},
function(Positionable) return {

	inherits = Positionable,

	members = function(self) return {
		
		_image = nil,

		init = function(image, x, y)
			self._image = love.graphics.newImage(image)

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