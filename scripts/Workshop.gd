extends Node2D

onready var game = get_node("../..")
onready var map = game.get_node("Map")
onready var ui = game.get_node("Ui")

const entityType = Data.ENTITY_TYPES.WORKSHOP
var type = Data.WORKSHOP_TYPES.Carpenter
var status = "toPlace"
var canBePlaced = true

var blockedTiles = [Vector2(-1,-1), Vector2(0,-1), Vector2(-1,1)]
var workshopSpace = [
	Vector2(-1,-1), Vector2(0,-1), Vector2(1,-1), 
	Vector2(-1, 0), Vector2(0, 0), Vector2(1, 0), 
	Vector2(-1, 1), Vector2(0, 1), Vector2(1, 1)
]

func _ready():
	$Button.action_mode = BaseButton.ACTION_MODE_BUTTON_RELEASE
	$Button.disabled = true
	$Button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	modulate.a = 0.5
	var mapPos = Utils.worldToMapPosition(position)
	for tile in workshopSpace:
		map.isTaken[mapPos.x + tile.x][mapPos.y + tile.y] = true

func init(index):
	type = index
	$Sprite.frame = Data.WORKSHOPS[index][1]

func _exit_tree():
	var mapPos = Utils.worldToMapPosition(position)
	if (status == "idle"):
		for tile in blockedTiles:
			map.isBlocked[mapPos.x + tile.x][mapPos.y + tile.y] = false
	for tile in workshopSpace:
		map.isTaken[mapPos.x + tile.x][mapPos.y + tile.y] = false

func move(newPos: Vector2):
	var mapPos = Utils.worldToMapPosition(newPos)
	position = mapPos * 16
	for tile in workshopSpace:
		if (map.isTaken[mapPos.x + tile.x][mapPos.y + tile.y] 
		|| map.isBlocked[mapPos.x + tile.x][mapPos.y + tile.y]):
			canBePlaced = false
			modulate.r = 1
			modulate.g = 0.5
			modulate.b = 0.5
			return
	canBePlaced = true
	modulate.r = 0.5
	modulate.g = 1
	modulate.b = 0.5

func place():
	if (!canBePlaced):
		return false
	status = "toBuild"
	var mapPos = Utils.worldToMapPosition(position)
	for tile in workshopSpace:
		map.isTaken[mapPos.x + tile.x][mapPos.y + tile.y] = true
	modulate.r = 1
	modulate.g = 1
	modulate.b = 1
	return true

func build():
	status = "idle"
	$Button.disabled = false
	$Button.mouse_filter = Control.MOUSE_FILTER_STOP
	modulate.a = 1.0
	var mapPos = Utils.worldToMapPosition(position)
	for tile in blockedTiles:
		map.isBlocked[mapPos.x + tile.x][mapPos.y + tile.y] = true

func _on_Button_pressed():
	ui.actionMenu.displayWorkshopActionMenu(self)
