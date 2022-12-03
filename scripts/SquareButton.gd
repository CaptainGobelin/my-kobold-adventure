tool
extends TextureButton
class_name SquareButton

enum TYPES {
	NONE,
	BUILD,
	BUILD_WORKSHOP,
	BUILD_FURNITURE,
	BUILD_STRUCTURE,
	ZONE,
	ZONE_STOCKPILE,
	ZONE_FARMLAND,
	MINE,
	GATHER,
	TASK,
	WORKSHOP,
	FURNITURE,
	RETURN
}

var PROPERTIES = {
	TYPES.NONE: 			[""],
	TYPES.BUILD: 			["B"],
	TYPES.BUILD_WORKSHOP: 	["W"],
	TYPES.BUILD_FURNITURE: 	["F"],
	TYPES.BUILD_STRUCTURE: 	["S"],
	TYPES.ZONE:				["Z"],
	TYPES.ZONE_STOCKPILE: 	["S"],
	TYPES.ZONE_FARMLAND: 	["F"],
	TYPES.MINE: 			["M"],
	TYPES.GATHER: 			["G"],
	TYPES.TASK: 			["T"],
	TYPES.WORKSHOP:			["W"],
	TYPES.FURNITURE:		["F"],
	TYPES.RETURN: 			["<-"],
}

export (TYPES) var ButtonType = TYPES.NONE setget changeType

onready var ui = get_node("../../../..")

func changeType(newType):
	ButtonType = newType
	$Label.text = PROPERTIES[newType][0]
	if (newType == TYPES.NONE):
		disabled = true
		modulate.a = 0
	else:
		disabled = false
		modulate.a = 1

func _ready():
	connect("button_up", ui, "_on_button_click", [self])
