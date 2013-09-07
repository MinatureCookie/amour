return class("PositionableContainer",
{
	amourPath("system/classes/sceneElements/Positionable"),
	amourPath("system/classes/List")
},
function(Positionable, List) return {

	inherits = Positionable,

	members = function(self) return {

		_positionables = List.create(),

		init = function(newPositionables)
			if(newPositionables == nil) then
				self._positionables = List.create()
			elseif(newPositionables.isA(List)) then
				self._positionables = newPositionables
			else
				self._positionables = List.create(newPositionables)
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