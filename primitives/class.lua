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
	if(initClass.statics ~= nil) then
		newClass.statics = initClass.statics
	end
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

	return newClass
end

function _initInstanceFieldsAndMethods(newInstance, uninstantiatedMembers)
	local instantiatedMembers = uninstantiatedMembers(newInstance)
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

function _generateSuper(newInstance, newClass)
	if(newClass.base ~= nil) then
		newInstance.super = newClass.base.members(newInstance)
		_filterForMethods(newInstance.super)
	end

	return newInstance.super
end

function _handleInstanceAccess(newInstance, newClass, table, key)
	local toReturn

	if(key == "super") then
		toReturn = _generateSuper(newInstance, newClass)
	elseif(newClass.base ~= nil) then
		_initInstanceFieldsAndMethods(newInstance, newClass.base.members)
		if(rawget(newInstance, key) == nil) then
			toReturn = _handleInstanceAccess(newInstance, newClass.base, table, key)
		else
			toReturn = newInstance[key]
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

		if(newClass.isSingleton == true) then
			newClass.create = function()
				return newInstance
			end
		end

		local newInstanceMt = {}
		setmetatable(newInstance, newInstanceMt)
		newInstanceMt.__index = bind(_handleInstanceAccess, newInstance, newClass)
		_initInstanceFieldsAndMethods(newInstance, newClass.members)

		if(newInstance.init ~= nil) then
			newInstance.init(...)
		end

		newInstance.statics = newClass.statics
		newInstance.isA = newClass.isA

		return newInstance
	end

	return createFunction
end

function _newClassIsA(newClass)
	local isAFunction = function(classInQuestion)
		local result = false
		local ourClass = newClass
		while(result == false and ourClass ~= nil) do
			if(ourClass.className == classInQuestion.className) then
				result = true
			end
			ourClass = ourClass.base
		end

		return result
	end

	return isAFunction
end