return class("Observer",
{
	amourPath("system/classes/MessageBus")
},
function(MessageBus) return {

	members = function(self) return {

		_messageBus = MessageBus.create(),

		addEventListener = function(name, callback, source)
			self._messageBus.addEventListener(name, callback, source)
		end,
		removeEventListener = function(name, callback, source)
			self._messageBus.removeEventListener(name, callback, source)
		end,
		addListener = function(name, callback, source)
			self._messageBus.addListener(name, callback, source)
		end,
		removeListener = function(name, callback, source)
			self._messageBus.removeListener(name, callback, source)
		end,

		sendEventMessage = function(name, source, data)
			self._messageBus.sendEventMessage(name, source, data)
		end,
		sendMessage = function(name, source, data)
			self._messageBus.sendMessage(name, source, data)
		end

	} end

}end)