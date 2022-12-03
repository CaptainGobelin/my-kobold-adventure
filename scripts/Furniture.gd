extends Node2D

onready var game = get_node("../..")
onready var map = game.get_node("Map")

const entityType = Data.ENTITY_TYPES.FURNITURE
var type = Data.FURNITURE_TYPES.Table
var status = "toPlace"
var canBePlaced = true

func _ready():
	modulate.a = 0.5
	var mapPos = Utils.worldToMapPosition(position)
	map.isTaken[mapPos.x][mapPos.y] = true

func init(index):
	type = index
	$Sprite.frame = Data.FURNITURES[index][1]

func _exit_tree():
	var mapPos = Utils.worldToMapPosition(position)
	if (status == "idle"):
		map.isBlocked[mapPos.x][mapPos.y] = false
	if (status == "toBuild"):
		map.isTaken[mapPos.x][mapPos.y] = false

func move(newPos: Vector2):
	var mapPos = Utils.worldToMapPosition(newPos)
	position = mapPos * 16
	if (map.isTaken[mapPos.x][mapPos.y] || map.isBlocked[mapPos.x][mapPos.y]):
		canBePlaced = false
		modulate.r = 1
		modulate.g = 0.5
		modulate.b = 0.5
	else:
		canBePlaced = true
		modulate.r = 0.5
		modulate.g = 1
		modulate.b = 0.5

func place():
	if (!canBePlaced):
		return false
	status = "toBuild"
	var mapPos = Utils.worldToMapPosition(position)
	map.isTaken[mapPos.x][mapPos.y] = true
	modulate.r = 1
	modulate.g = 1
	modulate.b = 1
	return true

func build():
	status = "idle"
	modulate.a = 1.0
	var x = floor(position.x/16)
	var y = floor(position.y/16)
	map.isBlocked[x][y] = true
	map.isTaken[x][y] = false
