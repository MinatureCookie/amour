return class("Array",
{},
function() return {

	members = function(self) return {

		_primitive = nil,
		_length = nil,

		_forEachDeleteQueue = {},

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

		assertType = function(item)
			if(self.type == nil) then
				self.type = type(item)
			end

			if(type(item) ~= self.type) then
				error("Array expected type " .. self.type .. " but instead got " .. type(item))
			end
		end,

		push = function(item)
			self.assertType(item)

			self._length = self._length + 1
			self._primitive[self._length] = item
		end,

		pop = function()
			local item = self._primitive[self._length]
			self._length = self._length - 1

			return item
		end,

		empty = function()
			for index, value in pairs(self._primitive) do
				self._primitive[index] = nil
			end
			self._primitive = {}
			self._length = 0
		end,

		get = function(index)
			return self._primitive[index]
		end,

		delete = function(index)
			if(self._length > 0) then
				self._primitive[index] = self._primitive[self._length]
				self._primitive[self._length] = nil
				self._length = self._length - 1
			end
		end,

		first = function()
			return self._primitive[1]
		end,
		last = function()
			return self._primitive[self._length]
		end,
		
		length = function()
			return self._length
		end,

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