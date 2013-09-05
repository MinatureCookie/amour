function class(name, required, uninstantiatedInitClass)
	local requiredArgs = {n = 0}
	for index, value in pairs(required) do
		requiredArgs.n = requiredArgs.n + 1
		requiredArgs[requiredArgs.n] = require(value)
	end

	local newClass = {}
	local initClass = uninstantiatedInitClass(unpack(requiredArgs))

	newClass.className = name
	newClass.statics = {}
	newClass.members = {}
	newClass.isSingleton = false
	if(initClass.members ~= nil) then
		newClass.members = initClass.members
	end
	if(initClass.singleton == true) then
		newClass.isSingleton = true
	end
	if(initClass.inherits ~= nil) then
		newClass.base = initClass.inherits
	end
	newClass.create = _newClassCreate(newClass)
	newClass.isA = _newClassIsA(newClass)
	newClass.destroy = _newClassDestroy(required)

	_setAllStatics(newClass, initClass.statics)

	return newClass
end

function _setAllStatics(newClass, statics)
	if(statics ~= nil) then
		newClass.statics = statics
	end

	if(newClass.base ~= nil) then
		for index, value in pairs(newClass.base.statics) do
			if(newClass.statics[index] == nil) then
				newClass.statics[index] = value
			end
		end
	end
end

function _initInstanceFieldsAndMethods(self, newInstance, uninstantiatedMembers)
	local instantiatedMembers = uninstantiatedMembers(self)
	for index, value in pairs(instantiatedMembers) do
		if(rawget(newInstance, index) == nil) then
			newInstance[index] = value
		end
	end
end

function _filterForMethods(table)
	for index, value in pairs(table) do
		if(type(value) ~= "function") then
			table[index] = nil
		end
	end
end

function _generateSuper(self, newInstance, newClass)
	local toReturn

	if(newClass.base ~= nil) then
		toReturn = newClass.base.members(newInstance)
		_filterForMethods(toReturn)
		newInstance.super = toReturn

		local superMt = {}
		setmetatable(newInstance.super, superMt)
		superMt.__index = bind(_handleInstanceAccess, self, newInstance.super, newClass.base)
	end

	return toReturn
end

function _handleInstanceAccess(self, newInstance, newClass, table, key)
	local toReturn

	if(key == "super") then
		toReturn = _generateSuper(self, newInstance, newClass)
	else

		if(rawget(newInstance, "_doNotLookFor") == nil) then
			newInstance._doNotLookFor = {}
		end

		if(not(newInstance._doNotLookFor.key)) then

			local currentClass = newClass
			while(currentClass ~= nil) do
				if(not(currentClass.isA(rawget(newInstance, "_lastClassCopy")))) then
					_initInstanceFieldsAndMethods(self, newInstance, currentClass.members)
					newInstance._lastClassCopy = currentClass
				end

				if(rawget(newInstance, key) ~= nil) then
					toReturn = newInstance[key]
					break
				end

				currentClass = currentClass.base
			end

			if(toReturn == nil) then
				newInstance._doNotLookFor.key = true
			end

		end

	end

	return toReturn
end

function _newClassDestroy(required)
	local destroyFunction = function()
		for index, value in pairs(required) do
			unload(value)
		end
	end
end

function _newClassCreate(newClass)
	local createFunction = function(...)
		local newInstance = {}

		newInstance.statics = newClass.statics
		newInstance.isA = newClass.isA
		newInstance.classValue = newClass

		if(newClass.isSingleton == true) then
			newClass.create = function()
				return newInstance
			end
		end

		local newInstanceMt = {}
		setmetatable(newInstance, newInstanceMt)
		newInstanceMt.__index = bind(_handleInstanceAccess, newInstance, newInstance, newClass)

		if(newInstance.init ~= nil) then
			newInstance.init(...)
		end

		return newInstance
	end

	return createFunction
end

function _newClassIsA(newClass)
	local isAFunction = function(classInQuestion)
		local result = false
		local ourClass = newClass

		if(classInQuestion ~= nil) then
			while(result == false and ourClass ~= nil) do
				if(ourClass.className == classInQuestion.className) then
					result = true
				end
				ourClass = ourClass.base
			end
		end

		return result
	end

	return isAFunction
end