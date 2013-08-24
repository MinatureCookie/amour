require("amour/primitives/methods/bind")

function class(base)
	local newClass = {}
	if(type(base) == "table") then
		newClass._base = base
	end
	newClass.__index = newClass

	return bind(_createClass, newClass)
end

function _createClass(newClass, initClass)
	newClass._initClass = initClass

	function newClass.isA(classType)
		if(classType == newClass) then
			return true
		elseif(newClass._base ~= nil) then

			return newClass._base.isA(classType)
		end

		return false
	end

	function newClass.create(...)
		local newInstance = {}
		setmetatable(newInstance, newClass)

		if(initClass ~= nil) then
			local fieldsAndMethods = initClass(newInstance)
			if(fieldsAndMethods.singleton == true) then
				function newClass.create()
					return newInstance
				end
			end

			_setFieldsAndMethods(newInstance, fieldsAndMethods, newClass)

			local currentParent = newClass._base
			while(currentParent ~= nil) do
				if(currentParent._initClass ~= nil) then
					fieldsAndMethods = currentParent._initClass(newInstance)
					_setFieldsAndMethods(newInstance, fieldsAndMethods, newClass)
				end

				currentParent = currentParent._base
			end
		end

		if(newInstance.init ~= nil) then
			newInstance.init(...)
		elseif(type(base) == "table" and base.init ~= nil) then
			base.init(...)
		end

		return newInstance
	end

	return newClass
end

function _superMustBeCalled(instance, index, value)
	return (type(instance[index]) == "function" and type(value) == "function"
			and
			(index == "init"
			or index == "destroy"))
end

function _setFieldsAndMethods(instance, fieldsAndMethods)
	for index, value in pairs(fieldsAndMethods) do

		if(instance[index] == nil) then
			instance[index] = value
		elseif(_superMustBeCalled(instance, index, value)) then
			local baseMethod = instance[index]
			instance[index] = function(...)
				baseMethod(...)
				value(...)
			end
		end

	end
end