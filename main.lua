local pathOfThisFile = ...
AMOUR_ROOT = pathOfThisFile:sub(0, -5)

require(AMOUR_ROOT .. "primitives/methods/amourPath")

require(amourPath("primitives/methods/requiring/requireAll"))

requireAll({
	amourPath("primitives"),
	amourPath("system/base")
})