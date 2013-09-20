--[[
	Class: Character

	Package:
		amour/assets/game/player

	Extends:
		<Positionable>

	Description:
		A character that can attach to a map, and is controlled by user input
--]]
return class("Character",
{
	amourPath("system/classes/sceneElements/Positionable"),
	amourPath("system/classes/Observer")
},
function(Positionable, Observer) return {

	inherits = Positionable,

	statics = {
		UP = 0,
		RIGHT = 1,
		DOWN = 2,
		LEFT = 3
	},

	members = function(self) return {

		_observer = Observer.create(),

		_characterDirection = self.statics.DOWN,
		_directionImageMap = {
			[self.statics.UP] = nil,
			[self.statics.RIGHT] = nil,
			[self.statics.DOWN] = nil,
			[self.statics.LEFT] = nil
		},
		_vx = 0,
		_vy = 0,
		_vmagnitude = 100,

		init = function(imageDirectory)
			self._directionImageMap[self.statics.UP] = love.graphics.newImage(imageDirectory .. "/up.png")
			self._directionImageMap[self.statics.RIGHT] = love.graphics.newImage(imageDirectory .. "/right.png")
			self._directionImageMap[self.statics.DOWN] = love.graphics.newImage(imageDirectory .. "/down.png")
			self._directionImageMap[self.statics.LEFT] = love.graphics.newImage(imageDirectory .. "/left.png")

			self._observer.addEventListener("keypressed", self._handleKeyPress)
			self._observer.addEventListener("keyreleased", self._handleKeyRelease)
		end,

		update = function(dt)
			self._handleVelocity(self._vx, self._vy, self._vmagnitude, dt)

			self._decideDirection()
		end,

		draw = function()
			local x = math.floor(self._x)
			local y = math.floor(self._y)
			love.graphics.draw(self._directionImageMap[self._characterDirection], x, y)
		end,

		setHandleVelocity = function(f)
			self._handleVelocity = f
		end,

		_handleVelocity = function(vx, vy, mag, dt)
			local velocitySquared = vx*vx + vy*vy
			if(velocitySquared ~= 0) then
				vx = vx*mag / velocitySquared
				vy = vy*mag / velocitySquared
			end

			self._x = self._x + vx*dt
			self._y = self._y + vy*dt
		end,

		_decideDirection = function()
			if(self._vy > 0) then
				self._characterDirection = self.statics.DOWN
			elseif(self._vx > 0) then
				self._characterDirection = self.statics.RIGHT
			elseif(self._vy < 0) then
				self._characterDirection = self.statics.UP
			elseif(self._vx < 0) then
				self._characterDirection = self.statics.LEFT
			end
		end,

		_handleKeyPress = function(data)
			if(data.key == "up") then
				self._vy = self._vy - 1
			elseif(data.key == "right") then
				self._vx = self._vx + 1
			elseif(data.key == "down") then
				self._vy = self._vy + 1
			elseif(data.key == "left") then
				self._vx = self._vx - 1
			end
		end,

		_handleKeyRelease = function(data)
			if(data.key == "up") then
				self._vy = self._vy + 1
			elseif(data.key == "right") then
				self._vx = self._vx - 1
			elseif(data.key == "down") then
				self._vy = self._vy - 1
			elseif(data.key == "left") then
				self._vx = self._vx + 1
			end
		end

	} end

}end)
