sceneElements = {}
sceneGlobals = {}
sceneRequisites = {}
oldRequire = nil
stage = Array.create()

function scene(required, initScene)
	clearScene()

	setSceneToGlobal({initScene})

	function sceneElements.addToStage(stageItem)
		stage.push(stageItem)
	end
	function sceneElements.loadScene()
	end
	function sceneElements.updateScene(dt)
	end

	for index, value in pairs(required) do
		sceneRequire(value)
	end

	local fieldsAndMethods = initScene(sceneElements)
	for index, value in pairs(fieldsAndMethods) do
		sceneElements[index] = value
	end

	sceneElements.loadScene()
end

function clearScene()
	unSetSceneFromGlobal()

	for index, value in pairs(sceneElements) do
		if(type(value) == "table" and type(value.destroy) == "function") then
			value.destroy()
		end
		sceneElements[index] = nil
	end
	sceneElements = {}

	for index, value in pairs(sceneGlobals) do
		if(type(value) == "table" and type(value.destroy) == "function") then
			value.destroy()
		end
		sceneGlobals[index] = nil
	end
	sceneGlobals = {}

	sceneRequisites = {}

	stage.empty()
end

function setSceneToGlobal(targets)
	setmetatable(sceneGlobals, {__index = _G})
	setfenv(0, sceneGlobals)

	if(targets ~= nil) then
		for index, value in pairs(targets) do
			setfenv(value, sceneGlobals)
		end
	end

	if(oldRequire == nil) then
		oldRequire = require
		require = sceneRequire
	end
end

function unSetSceneFromGlobal()
	setfenv(0, _G)

	if(oldRequire ~= nil) then
		require = oldRequire
		oldRequire = nil
	end
end

function sceneRequire(required)
	setSceneToGlobal()
	if(not(sceneRequisites[required] or _LOADED[required])) then
		print("Requiring " .. required)
		love.filesystem.load(required .. ".lua")()
		sceneRequisites[required] = true
	end
end

function love.draw()
	stage.forEach(function(stageItem)
		stageItem.draw()
	end)
end

function love.update(dt)
	if(pollMousePosition) then
		pollMousePosition()
	end

	sceneElements.updateScene(dt)
end