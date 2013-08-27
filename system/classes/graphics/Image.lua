return class("Image",
{
	"amour/system/classes/sceneElements/Positionable"
},
function(Positionable) return {

	inherits = Positionable,

	members = function(self) return {

		init = function(image, x, y)
			self.image = love.graphics.newImage(image)

			if(x ~= nil) then
				self.x = x
			end
			if(y ~= nil) then
				self.y = y
			end
		end,

		getWidth = function()
			return self.image:getWidth()
		end,
		getHeight = function()
			return self.image:getHeight()
		end,

		draw = function()
			love.graphics.draw(self.image, self.x, self.y)
		end

	} end

}end)