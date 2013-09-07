return class("MessageBus",
{
	amourPath("system/classes/List")
},
function(List) return {

	singleton = true,

	members = function(self) return {

		_messageBusBusy = false,
		_messageBusBusyQueue = List.create(),

		_generalListeners = List.create(),
		_eventListeners = List.create(),

		addEventListener = function(name, callback, source)
			self._addListener(self._eventListeners, name, callback, source)
		end,
		removeEventListener = function(name, callback, source)
			self._removeListener(self._eventListeners, name, callback, source)
		end,
		addListener = function(name, callback, source)
			self._addListener(self._generalListeners, name, callback, source)
		end,
		removeListener = function(name, callback, source)
			self._removeListener(self._generalListeners, name, callback, source)
		end,

		sendEventMessage = function(name, source, data)
			self._sendMessage(self._eventListeners, name, source, data)
		end,

		sendMessage = function(name, source, data)
			self._sendMessage(self._generalListeners, name, source, data)
		end,

		_freeMessageBus = function()
			self._messageBusBusy = false

			self._messageBusBusyQueue.forEach(function(callback)
				callback()
			end)
			self._messageBusBusyQueue.empty()
		end,

		_addListener = function(listeners, name, callback, source)
			if(self._messageBusBusy) then
				self._messageBusBusyQueue.push(bind(self._addListener, listeners, name, callback, source))
			else
				local targetListener = listeners

				if(source ~= nil) then
					if(source.listeners == nil) then
						source.listeners = List.create()
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
			if(self._messageBusBusy) then
				self._messageBusBusyQueue.push(bind(self._removeListener, listeners, name, callback, source))
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
			self._messageBusBusy = true

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
		end

	} end

}end)