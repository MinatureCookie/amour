--[[
	Class: Observer

	Package:
		amour/system/classes

	Description:
		Elements wanting to use the <MessageBus> should not used the message bus directly, but instead
		get a private observer element to use

	See also:
		<MessageBus>
--]]
return class("Observer",
{
	amourPath("system/classes/MessageBus")
},
function(MessageBus) return {

	members = function(self) return {

		_messageBus = MessageBus.create(),

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
			self._messageBus.addEventListener(name, callback, source)
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
			self._messageBus.removeEventListener(name, callback, source)
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
			self._messageBus.addListener(name, callback, source)
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
			self._messageBus.removeListener(name, callback, source)
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
			self._messageBus.sendEventMessage(name, source, data)
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
			self._messageBus.sendMessage(name, source, data)
		end

	} end

}end)