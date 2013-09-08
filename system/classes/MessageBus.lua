--[[
	Class: MessageBus

	Package:
		amour/system/classes

	Singleton:
		true

	Description:
		The message bus used to send messages throughout an amour project. Note, elements wanting to use the message bus
		should not used the message bus directly, but instead get a private <Observer> element to use

	See also:
		<Observer>
--]]
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

		--[[
			Function: addEventListener

			Description:
				Adds a listener to the event queue. The event queue should be used for system input, such as
				mouse events, keyboard events, etc.

			Parameters:
				name - The name of message we want to listen for
				callback - The method to call when we hear the message
				source - If specified, will only activate if also specified in the message. (Specifying a source
				means the message bus used is specific to the source, and is thus less congested)
		--]]
		addEventListener = function(name, callback, source)
			self._addListener(self._eventListeners, name, callback, source)
		end,
		--[[
			Function: removeEventListener

			Description:
				Removes a listener from the event queue

			Parameters:
				name - The name specified in addEventListener
				callback - The callback specified in addEventListener
				source - The source specified in addEventListener
		--]]
		removeEventListener = function(name, callback, source)
			self._removeListener(self._eventListeners, name, callback, source)
		end,
		--[[
			Function: addListener

			Description:
				Adds a listener to the general queue. The general queue should be used for events such as
				PLAYER_HAS_DIED, or FINISHED_DOWNLOADING_MUSIC

			Parameters:
				name - The name of message we want to listen for
				callback - The method to call when we hear the message
				source - If specified, will only activate if also specified in the message. (Specifying a source
				means the message bus used is specific to the source, and is thus less congested)
		--]]
		addListener = function(name, callback, source)
			self._addListener(self._generalListeners, name, callback, source)
		end,
		--[[
			Function: removeListener

			Description:
				Removes a listener from the general queue

			Parameters:
				name - The name specified in addEventListener
				callback - The callback specified in addEventListener
				source - The source specified in addEventListener
		--]]
		removeListener = function(name, callback, source)
			self._removeListener(self._generalListeners, name, callback, source)
		end,

		--[[
			Function: sendEventMessage

			Description:
				Sends a message about an event (see addEventListener)

			Parameters:
				name - The name of the message
				source - If specified, only activates listeners registered under the same source
				data - A data object to be provided to the callback of any listeners activated
		--]]
		sendEventMessage = function(name, source, data)
			self._sendMessage(self._eventListeners, name, source, data)
		end,

		--[[
			Function: sendMessage

			Description:
				Sends a general message (see addListener)

			Parameters:
				name - The name of the message
				source - If specified, only activates listeners registered under the same source
				data - A data object to be provided to the callback of any listeners activated
		--]]
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