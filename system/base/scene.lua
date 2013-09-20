local ClickableContainer = require(amourPath("system/classes/sceneElements/ClickableContainer"))

local _sceneElements = {}
local _oldRequire = {}
local _currentScene = nil
local _stage = ClickableContainer.create()

--[[
	Function: scene

	Package:
		amour/system/base

	Description:
		Clears the old scene, and sets the new scene as this one

	Parameters:
		required - An object list of string locations to assets required by the scene
		initScene - A context function providing context for 'required', and the stage
--]]
function scene(required, initScene)
	clearScene()

	function _sceneElements.addToStage(stageItem)
		_stage.addNew(stageItem)
	end
	function _sceneElements.loadScene()
	end
	function _sceneElements.updateScene(dt)
	end

	local requiredArgs = {n = 0}
	for index, value in pairs(required) do
		requiredArgs.n = requiredArgs.n + 1
		requiredArgs[requiredArgs.n] = require(value)
		_oldRequire[index] = value
	end

	local fieldsAndMethods = initScene(unpack(mergePacked(requiredArgs, {n = 1, [1] = _sceneElements})))
	for index, value in pairs(fieldsAndMethods) do
		_sceneElements[index] = value
	end

	_sceneElements.loadScene()

	print()
	print("-----Scene " .. _currentScene .. " loaded-----")
	print()
end

--[[
	Function: changeScene

	Package:
		amour/system/base

	Description:
		Loads a scene file, and changes to scene to new one

	Parameters:
		newScene - A string location to the scene file we want to load
--]]
function changeScene(newScene)
	if(_currentScene ~= nil) then
		unload(_currentScene)
	end
	_currentScene = newScene
	require(newScene)
end

--[[
	Function: clearScene

	Package:
		amour/system/base

	Description:
		Clears the current scene (is called automatically by 'scene'
--]]
function clearScene()
	for index, value in pairs(_sceneElements) do
		if(type(value) == "table" and type(value.destroy) == "function") then
			value.destroy()
		end
		_sceneElements[index] = nil
	end
	_sceneElements = {}

	for index, value in pairs(_oldRequire) do
		unload(value)
		_oldRequire[index] = nil
	end
	_oldRequire = {}

	_stage.empty()
end

function love.draw()
	_stage.draw()
end

function love.update(dt)
	_stage.pollMousePosition()

	_stage.update(dt)
	_sceneElements.updateScene(dt)
end