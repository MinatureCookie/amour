return class("Observer",
{
	"amour/system/classes/MessageBus"
},
function(MessageBus) return {

	members = function(self) return {

		messageBus = MessageBus.create(),

		addEventListener = function(name, callback, source)
			self.messageBus.addEventListener(name, callback, source)
		end,
		removeEventListener = function(name, callback, source)
			self.messageBus.removeEventListener(name, callback, source)
		end,
		addListener = function(name, callback, source)
			self.messageBus.addListener(name, callback, source)
		end,
		removeListener = function(name, callback, source)
			self.messageBus.removeListener(name, callback, source)
		end,

		sendEventMessage = function(name, source, data)
			self.messageBus.sendEventMessage(name, source, data)
		end,
		sendMessage = function(name, source, data)
			self.messageBus.sendMessage(name, source, data)
		end

	} end

}end)