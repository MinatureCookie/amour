sceneElements = {}
sceneGlobals = {}
oldRequire = {}
currentScene = nil
stage = Array.create()

function scene(required, initScene)
	clearScene()

	function sceneElements.addToStage(stageItem)
		stage.push(stageItem)
	end
	function sceneElements.loadScene()
	end
	function sceneElements.updateScene(dt)
	end

	local requiredArgs = {n = 0}
	for index, value in pairs(required) do
		requiredArgs.n = requiredArgs.n + 1
		requiredArgs[requiredArgs.n] = require(value)
		oldRequire[index] = value
	end

	local fieldsAndMethods = initScene(unpack(mergePacked(requiredArgs, {n = 1, [1] = sceneElements})))
	for index, value in pairs(fieldsAndMethods) do
		sceneElements[index] = value
	end

	sceneElements.loadScene()
end

function changeScene(newScene)
	if(currentScene ~= nil) then
		unload(currentScene)
	end
	currentScene = newScene
	require(newScene)
end

function clearScene()
	for index, value in pairs(sceneElements) do
		if(type(value) == "table" and type(value.destroy) == "function") then
			value.destroy()
		end
		sceneElements[index] = nil
	end
	sceneElements = {}

	for index, value in pairs(oldRequire) do
		unload(value)
		oldRequire[index] = nil
	end
	oldRequire = {}

	stage.empty()
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