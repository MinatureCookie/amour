return class("PositionableContainer",
{
	amourPath("system/classes/sceneElements/Positionable")
},
function(Positionable) return {

	inherits = Positionable,

	members = function(self) return {

		_positionables = Array.create(),

		init = function(newPositionables)
			if(newPositionables == nil) then
				self._positionables = Array.create()
			elseif(newPositionables.isA(Array)) then
				self._positionables = newPositionables
			else
				self._positionables = Array.create(newPositionables)
			end
		end,

		addNew = function(newPositionable)
			self._positionables.push(newPositionable)
		end,

		empty = function()
			self._positionables.empty()
		end,

		draw = function()
			self._positionables.forEach(function(value)
				value.draw()
			end)
		end,

		destroy = function()
			self._positionables.forEach(function(value)
				value.destroy()
			end)
			self._positionables = {}
		end

	} end

}end)