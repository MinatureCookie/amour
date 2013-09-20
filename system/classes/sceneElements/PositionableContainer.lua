--[[
	Class: PositionableContainer

	Package:
		amour/system/classes/sceneElements

	Extends:
		<Positionable>

	Description:
		A collection of positionable elements that will all be drawn when it is
--]]
return class("PositionableContainer",
{
	amourPath("system/classes/sceneElements/Positionable"),
	amourPath("system/classes/List")
},
function(Positionable, List) return {

	inherits = Positionable,

	members = function(self) return {

		_positionables = List.create(),

		--[[
			Function: init

			Parameters:
				newPositionables - An object list, or a <List>, of elements to originally add. (Can be nil)
		--]]
		init = function(newPositionables)
			if(newPositionables == nil) then
				self._positionables = List.create()
			elseif(newPositionables.isA(List)) then
				self._positionables = newPositionables
			else
				self._positionables = List.create(newPositionables)
			end
		end,

		--[[
			Function: addNew

			Parameters:
				newPositionable - A positionable element to add to this container
		--]]
		addNew = function(newPositionable)
			self._positionables.push(newPositionable)
		end,

		--[[
			Function: empty

			Description:
				Empties the container of all of its current elements
		--]]
		empty = function()
			self._positionables.empty()
		end,

		--[[
			Function: draw

			Description:
				Draws all of the elements in the container
		--]]
		draw = function()
			self._positionables.forEach(function(value)
				value.draw()
			end)
		end,

		--[[
			Function: update

			Parameters:
				dt - The fraction of time passed since the update method was last called

			Description:
				Updates all of the elements in the container, whenever possible
		--]]
		update = function(dt)
			self._positionables.forEach(function(value)
				if(type(value.update) == "function") then
					value.update(dt)
				end
			end)
		end,

		--[[
			Function: destroy

			Description:
				Prepare the current container, and all of its elements, for destruction
		--]]
		destroy = function()
			self._positionables.forEach(function(value)
				value.destroy()
			end)
			self._positionables = {}
		end

	} end

}end)