return class("MessageBus",
{},
function() return {

	singleton = true,

	members = function(self) return {

		messageBusBusy = false,
		messageBusBusyQueue = Array.create(),

		generalListeners = Array.create(),
		eventListeners = Array.create(),

		_freeMessageBus = function()
			self.messageBusBusy = false

			self.messageBusBusyQueue.forEach(function(callback)
				callback()
			end)
			self.messageBusBusyQueue.empty()
		end,

		_addListener = function(listeners, name, callback, source)
			if(self.messageBusBusy) then
				self.messageBusBusyQueue.push(bind(self._addListener, listeners, name, callback, source))
			else
				local targetListener = listeners

				if(source ~= nil) then
					if(source.listeners == nil) then
						source.listeners = Array.create()
					end

					targetListener = source.listeners
				end

				targetListener.push({
					["name"] = name,
					["callback"] = callback
				})
			end
		end,

		_removeListener = function(listeners, name, callback, source)
			if(self.messageBusBusy) then
				self.messageBusBusyQueue.push(bind(self._removeListener, listeners, name, callback, source))
			else
				local targetListener = listeners

				if(source ~= nil and source.listeners ~= nil) then
					targetListener = source.listeners
				end

				targetListener.forEach(function(value, index)
					if(value.name == name and value.callback == callback) then
						targetListener.deleteInForEach(index)
					end
				end)
			end
		end,

		_sendMessage = function(listeners, name, source, data)
			self.messageBusBusy = true

			local function callListener(listener)
				if(listener["name"] == name) then
					listener["callback"](data)
				end
			end

			if(source ~= nil and source.listeners ~= nil) then
				source.listeners.forEach(callListener)
			else
				listeners.forEach(callListener)
			end

			self._freeMessageBus()
		end,

		addEventListener = function(name, callback, source)
			self._addListener(self.eventListeners, name, callback, source)
		end,
		removeEventListener = function(name, callback, source)
			self._removeListener(self.eventListeners, name, callback, source)
		end,
		addListener = function(name, callback, source)
			self._addListener(self.generalListeners, name, callback, source)
		end,
		removeListener = function(name, callback, source)
			self._removeListener(self.generalListeners, name, callback, source)
		end,

		sendEventMessage = function(name, source, data)
			self._sendMessage(self.eventListeners, name, source, data)
		end,

		sendMessage = function(name, source, data)
			self._sendMessage(self.generalListeners, name, source, data)
		end

	} end
}end)