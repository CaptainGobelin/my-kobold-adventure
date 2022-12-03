extends Node2D

onready var game = get_node("../..")
onready var map = game.get_node("Map")

func _ready():
	var mapPos = Utils.worldToMapPosition(position)
	map.isBlocked[mapPos.x][mapPos.y] = true

func _exit_tree():
	var mapPos = Utils.worldToMapPosition(position)
	map.isBlocked[mapPos.x][mapPos.y] = false

func move(newPos: Vector2):
	var oldPos = Utils.worldToMapPosition(position)
	position = newPos
	var mapPos = Utils.worldToMapPosition(position)
	map.isBlocked[mapPos.x][mapPos.y] = true
	map.isBlocked[oldPos.x][oldPos.y] = false
