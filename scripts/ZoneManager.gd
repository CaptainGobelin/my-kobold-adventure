extends Control

onready var game = get_node("..")
onready var map = game.get_node("Map")
onready var ui = game.get_node("Ui")
onready var mouseManager = game.get_node("MouseManager")
onready var tilemap = get_node("TileMap")
onready var sprite = get_node("Sprite")

var startDraw = false
var startErase = false

signal zoneCompleted(tiles)

func _ready():
	disable()

func enable():
	ui.visible = false
	mouseManager.visible = false
	set_process_input(true)
	visible = true
	startDraw = false
	startErase = false
	tilemap.clear()

func disable():
	ui.visible = true
	mouseManager.visible = true
	set_process_input(false)
	visible = false
	startDraw = false
	startErase = false

func _gui_input(event):
	if (event is InputEventMouseButton && event.button_index == BUTTON_LEFT):
		if (event.is_pressed()):
			startDraw = true
			addTile()
		else:
			startDraw = false
	elif (event is InputEventMouseButton && event.button_index == BUTTON_RIGHT):
		if (event.is_pressed()):
			startErase = true
			if (!startDraw):
				clearTile()
		else:
			startErase = false
	elif (event is InputEventMouseMotion):
		var mousePos = get_viewport().get_mouse_position()
		mousePos = Utils.worldToMapPosition(mousePos)
		sprite.position = mousePos * 16
		if (startDraw):
			addTile()
		elif (startErase):
			clearTile()

func _input(event):
	if (event.is_action_released("ui_cancel")):
		disable()
	elif (event.is_action_released("ui_accept")):
		disable()
		emit_signal("zoneCompleted", tilemap.get_used_cells_by_id(0))

func addTile():
	var mousePos = get_viewport().get_mouse_position()
	var mapPos = Utils.worldToMapPosition(mousePos)
	if (map.isTaken[mapPos.x][mapPos.y] || map.isBlocked[mapPos.x][mapPos.y]):
		tilemap.set_cell(mapPos.x, mapPos.y, 1)
	else:
		tilemap.set_cell(mapPos.x, mapPos.y, 0)

func clearTile():
	var mousePos = get_viewport().get_mouse_position()
	var mapPos = Utils.worldToMapPosition(mousePos)
	tilemap.set_cell(mapPos.x, mapPos.y, TileMap.INVALID_CELL)
