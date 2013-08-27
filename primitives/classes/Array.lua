Array = class("Array",
{},
function() return {

	members = function(self) return {
		primitive = nil,
		length = nil,

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

			self.primitive = arr
			self.length = length
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

			self.length = self.length + 1
			self.primitive[self.length] = item
		end,

		pop = function()
			local item = self.primitive[self.length]
			self.length = self.length - 1

			return item
		end,

		empty = function()
			for index, value in pairs(self.primitive) do
				self.primitive[index] = nil
			end
			self.primitive = {}
			self.length = 0
		end,

		get = function(index)
			return self.primitive[index]
		end,

		delete = function(index)
			if(self.length > 0) then
				self.primitive[index] = self.primitive[self.length]
				self.primitive[self.length] = nil
				self.length = self.length - 1
			end
		end,

		first = function()
			return self.primitive[1]
		end,

		last = function()
			return self.primitive[self.length]
		end,

		forEach = function(callback)
			local index = 1
			while(index <= self.length) do
				local result = callback(self.primitive[index], index)

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

return Array