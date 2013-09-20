--[[
	Class: Character

	Package:
		amour/assets/game/player

	Extends:
		<Positionable>

	Description:
		A character that can attach to a map, and is controlled by user input
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

		init = function(tiledLua, chunkSize)
			-- TODO This needs to be moved, and not static .png ...
			self._tileset = love.graphics.newImage("images/scenery/tileset.png")
			self._chunkSize = chunkSize

			local tiledDetails = love.filesystem.load(tiledLua .. ".lua")()
			self._loadImageFrom(tiledDetails)
		end,

		draw = function()
			for index, ival in pairs(self._mapImage) do
				for jndex, value in pairs(ival) do
					love.graphics.draw(value,
						index*self._chunkSize*self._tileWidth,
						jndex*self._chunkSize*self._tileHeight)
				end
			end
		end,

		_loadImageFrom = function(tiledDetails)
			self._tileWidth = tiledDetails.tilewidth
			self._tileHeight = tiledDetails.tileheight
			for index, value in pairs(tiledDetails.layers) do
				if(value.name ~= "Trees" and value.name ~= "Floor") then
					self._drawLayer(value, tiledDetails.tilesets)
				end
			end
			self._cookAndClearRawMap()
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
			while(jndex <= yLimit) do
				while(index <= xLimit) do
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
						tilesetX + tileset.tilewidth, tilesetY + tileset.tileheight,
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