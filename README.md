# Amour
## What is Amour?
Amour is an extension to the game engine [Love2D](https://love2d.org/). It offers classes, scenes, events, listeners, and much more.

## Why should I care?
The whole point of this extension is to make using Love2D easier. To make it easier to keep your code clean, and add a structure to your code that makes large game project much easier to maintain.

Amour should also save you a lot of work reinventing wheels, with assets ready to use.

## How to use
(Assuming [Love2D](https://love2d.org/) is already installed and well understood)

To use Amour, simply have your __main.lua__ `require` Amour, and then load your first scene

    require("amour/main.lua")
    changeScene("myMenuDirectory/myPrimaryMenuScene.lua")

A bare-bones scene file might look like this

    scene({
    	"path/to/Class1",
    	"path/to/Class2"
    },
    function(stage, Class1, Class2) return {
    
    	loadScene = function()
    		local myDrawable = Class1.create()
    		stage.addToStage(myDrawable)
    		
    		print("Our scene has been loaded")
    	end,

    	updateScene = function(dt)
    		print("Our stage has been updated, " .. dt .. "ms has passed")
    	end
    
    } end )

## Getting started
### Wiki
The wiki [here](../../amour/wiki) on GitHub should have enough detail to get you ready to use Amour from scratch.

If you feel the wiki is lacking somewhere, or if something doesn't make sense - please do contribute!

### Examples
There are a load of examples in the __examples__ directory.

Note, none of these examples will actually work until their __main.lua__ points to a valid __amour__ directory.

### Documentation
The classes provided by Amour have auto-generated documentation that can be viewed in the __documentation__ directory.
