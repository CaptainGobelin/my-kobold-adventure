extends Control

onready var game = get_node("..")
onready var furnitureManager = game.get_node("FurnitureManager")
onready var workshopManager = game.get_node("WorkshopManager")
onready var ui = game.get_node("Ui")
onready var sprite = get_node("Sprite")

var currentThing = null

func _ready():
	set_process_input(true)

func _gui_input(event):
	if (event is InputEventMouseMotion):
		var mousePos = get_viewport().get_mouse_position()
		mousePos = Utils.worldToMapPosition(mousePos)
		sprite.position = mousePos * 16
		if (currentThing == null || !currentThing.has_method("move")):
			currentThing = null
			return
		currentThing.move(mousePos * 16)
	elif (event is InputEventMouseButton && !event.is_pressed()):
		if (event.button_index == BUTTON_LEFT):
			ui.actionMenu.displayMainActionMenu()
			if (currentThing == null):
				currentThing = null
				return
			match currentThing.entityType:
				Data.ENTITY_TYPES.FURNITURE:
					if (furnitureManager.place(currentThing)):
						currentThing = null
				Data.ENTITY_TYPES.WORKSHOP:
					if (workshopManager.place(currentThing)):
						currentThing = null
		elif (event.button_index == BUTTON_RIGHT):
			cancelPlace()
			currentThing = null
			ui.actionMenu.displayMainActionMenu()

func placeThing(thing):
	cancelPlace()
	currentThing = thing
	var mousePos = get_viewport().get_mouse_position()
	mousePos = Utils.worldToMapPosition(mousePos)
	sprite.position = mousePos * 16
	currentThing.move(mousePos * 16)

func cancelPlace():
	if (currentThing == null):
		return
	else:
		currentThing.queue_free()
