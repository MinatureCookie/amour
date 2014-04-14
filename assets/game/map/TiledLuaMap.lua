--[[
	Class: TiledLuaMap

	Package:
		amour/assets/game/map

	Extends:
		<Positionable>

	Description:
		A map that takes a "Tiled" map's .lua export,
--]]
return class("TiledLuaMap",
{
	amourPath("system/classes/sceneElements/Positionable"),
},
function(Positionable) return {

	inherits = Positionable,

	members = function(self) return {

		_mapImageRaw = {},
		_tileset = nil,

		_mapImage = {},
		_tileWidth = 0,
		_tileHeight = 0,
		_chunkSize = 0,

		--[[
			Function: init

			Parameters:
				tiledLua - The directory location of the Tiled *.lua export
				chunkSize - The chunk size of your Tiled map
		--]]
		init = function(tiledLua, chunkSize)
			self._chunkSize = chunkSize

			local tiledDetails = love.filesystem.load(tiledLua .. ".lua")()
			self._loadImageFrom(tiledDetails, tiledLua)
		end,

		--[[
			Function: init

			Description:
				Draws the map to the screen
		--]]
		draw = function()
			for index, ival in pairs(self._mapImage) do
				for jndex, value in pairs(ival) do
					love.graphics.draw(value,
						index*self._chunkSize*self._tileWidth,
						jndex*self._chunkSize*self._tileHeight)
				end
			end
		end,

		_loadImageFrom = function(tiledDetails, tiledLua)
			self._tileWidth = tiledDetails.tilewidth
			self._tileHeight = tiledDetails.tileheight

			local image, parentCount = self._removeParentTraversal(tiledDetails.tilesets[1].image)
			local imageDir = self._traverseParents(tiledLua, parentCount)
			self._tileset = love.graphics.newImage(imageDir .. image)

			for index, value in pairs(tiledDetails.layers) do
				self._drawLayer(value, tiledDetails.tilesets)
			end
			self._cookAndClearRawMap()
		end,

		_removeParentTraversal = function(image)
			local parentCount = 0
			while string.sub(image, parentCount * 3, (parentCount + 1) * 3) == "../" do
				parentCount = parentCount + 1
			end

			return string.sub(image, parentCount * 3 + 1), parentCount
		end,

		_traverseParents = function(file, parentCount)
			local fileSplit = string.gmatch(file, "([^/]+)")
			local fileSplitCount = 0
			for f in fileSplit do
				fileSplitCount = fileSplitCount + 1
			end

			local finalFileString = ""
			local index = 1
			for f in fileSplit do
				if index > fileSplitCount - parentCount - 1 then
					break
				else
					index = index + 1
				end

				finalFileString = finalFileString .. f .. "/"
			end

			return finalFileString
		end,

		_getDirectory = function(file)
			local lastSlashIndex = string.find(file, "/[^/]*$")
			local directory = file
			if(lastSlashIndex ~= nil) then
				directory = string.sub(file, 0, 1 - lastSlashIndex)
			end

			return directory
		end,

		_cookAndClearRawMap = function()
			for index, ivalue in pairs(self._mapImageRaw) do
				self._mapImage[index] = {}
				for jndex, jvalue in pairs(ivalue) do
					self._mapImage[index][jndex] = love.graphics.newImage(jvalue:getImageData())
				end
			end

			self._mapImageRaw = {}
		end,

		_drawLayer = function(layer, tilesets)
			for index = 1, layer.width, self._chunkSize do
				if(self._mapImageRaw[(index - 1)/self._chunkSize] == nil) then
					self._mapImageRaw[(index - 1)/self._chunkSize] = {}
				end

				for jndex = 1, layer.height, self._chunkSize do
					self._drawRawChunk(index, jndex, layer, tilesets)
				end
			end
		end,

		_drawRawChunk = function(index, jndex, layer, tilesets)
			local imageChunk = self._mapImageRaw[(index - 1)/self._chunkSize][(jndex - 1)/self._chunkSize]
			if(imageChunk == nil) then
				imageChunk = love.graphics.newCanvas(self._chunkSize*self._tileWidth,
					self._chunkSize*self._tileHeight)
				self._mapImageRaw[(index - 1)/self._chunkSize][(jndex - 1)/self._chunkSize] = imageChunk
			end
			local xLimit = math.min(index + self._chunkSize, layer.width)
			local yLimit = math.min(jndex + self._chunkSize, layer.height)
			while(jndex < yLimit) do
				while(index < xLimit) do
					self._pasteFromTilesetAt(index, jndex, layer, tilesets, imageChunk)

					index = index + 1
				end
				jndex = jndex + 1
				index = index - self._chunkSize
			end
		end,

		_pasteFromTilesetAt = function(index, jndex, layer, tilesets, imageChunk)
			local number = self._getNumberAt(index, jndex, layer)
			if(number ~= 0) then
				local tileset, tilesetX, tilesetY = self._getTilesetAndCoords(number, tilesets)
				imageChunk:renderTo(function()
					local cropper = love.graphics.newQuad(tilesetX, tilesetY,
						tileset.tilewidth, tileset.tileheight,
						self._tileset:getWidth(), self._tileset:getHeight())
					love.graphics.drawq(self._tileset,
						cropper,
						((index - 1) % self._chunkSize)*self._tileWidth,
						((jndex - 1) % self._chunkSize)*self._tileHeight)
				end)
			end
		end,

		_getNumberAt = function(index, jndex, layer)
			return layer.data[((jndex - 1)*layer.width) + index]
		end,

		_getTilesetAndCoords = function(number, tilesets)
			local tileset = tilesets[1]
			local rawX = (number - 1) * tileset.tilewidth
			local x = rawX % tileset.imagewidth
			local y = math.floor(rawX / tileset.imagewidth) * tileset.tileheight

			return tileset, x, y
		end

	} end

} end )