--[[
	Class: List

	Package:
		amour/system/classes

	Description:
		An ordered (note: ordered, not sorted!) list of elements
--]]
return class("List",
{},
function() return {

	members = function(self) return {

		_primitive = nil,
		_length = nil,
		_type = nil,

		_forEachDeleteQueue = {},

		--[[
			Function: init

			Parameters:
				arr - An object list to initialise the list with
		--]]
		init = function(arr)
			if(arr == nil) then
				arr = {}
			end

			local length = 0
			while(arr[length + 1] ~= nil) do
				length = length + 1

				self.assertType(arr[length])
			end

			self._primitive = arr
			self._length = length
		end,

		--[[
			Function: assertType

			Description:
				Asserts that an item is of valid type to be in this list

			Parameters:
				item - The item to assert the type of
		--]]
		assertType = function(item)
			if(self._type == nil) then
				self._type = type(item)
			end

			if(type(item) ~= self._type) then
				error("List expected type " .. self._type .. " but instead got " .. type(item))
			end
		end,

		--[[
			Function: push

			Description:
				Pushes a new item to the end of the list

			Parameters:
				item - The item to add
		--]]
		push = function(item)
			self.assertType(item)

			self._length = self._length + 1
			self._primitive[self._length] = item
		end,

		--[[
			Function: pop

			Description:
				Removes the last element of the list, and returns it

			Returns:
				The last element of the list
		--]]
		pop = function()
			local item = self._primitive[self._length]

			self._primitive[self._length] = nil
			self._length = self._length - 1

			return item
		end,

		--[[
			Function: empty

			Description:
				Empties the current list
		--]]
		empty = function()
			for index, value in pairs(self._primitive) do
				self._primitive[index] = nil
			end
			self._primitive = {}
			self._length = 0
		end,

		--[[
			Function: get

			Parameters:
				index - The index of item we want from the list

			Returns:
				The item at the index specified
		--]]
		get = function(index)
			return self._primitive[index]
		end,

		--[[
			Function: delete

			Parameters:
				index - The index of the item we want to remove from the list
		--]]
		delete = function(index)
			while(index <= self._length) do
				self._primitive[index] = self._primitive[index + 1]
				index = index + 1
			end

			self._length = self._length - 1
		end,

		--[[
			Function: first

			Returns:
				The first element of the list
		--]]
		first = function()
			return self._primitive[1]
		end,
		--[[
			Function: last

			Returns:
				The last element of the list
		--]]
		last = function()
			return self._primitive[self._length]
		end,

		--[[
			Function: length

			Returns:
				The length of the list
		--]]
		length = function()
			return self._length
		end,

		--[[
			Function: forEach

			Description:
				Loops through the list, calling a function(value, index) each time. The callback function returning 'false'
				is equivalent to a 'break'

			Parameters:
				callback - The function(value, index) to call on each list item
		--]]
		forEach = function(callback)
			local index = 1
			while(index <= self._length) do
				local result = callback(self._primitive[index], index)

				if(result == false) then
					break
				end

				index = index + 1
			end

			self._emptyForEachDeleteQueue()
		end,

		--[[
			Function: deleteInForEach

			Description:
				Deleting elements in a list is unsafe within a forEach, so instead use this when in a forEach loop

			Parameters:
				index - The index of the item we want to remove from the list
		--]]
		deleteInForEach = function(index)
			self._forEachDeleteQueue[index] = true
		end,

		_emptyForEachDeleteQueue = function()
			for index, value in pairs(self._forEachDeleteQueue) do
				self.delete(index)
			end

			self._forEachDeleteQueue = {}
		end
	} end

}end)