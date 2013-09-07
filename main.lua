local pathOfThisFile = ...
AMOUR_ROOT = pathOfThisFile:sub(0, -5)

require(AMOUR_ROOT .. "primitives/amourPath")

require(amourPath("primitives/requiring/requireAll"))

requireAll({
	amourPath("primitives"),
	amourPath("system/base")
})