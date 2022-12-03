extends Node

onready var game = get_node("..")
onready var map = game.get_node("Map")
onready var orderManager = game.get_node("OrderManager")

onready var workshopScene = load("res://scenes/Workshop.tscn")

var workshopSpace = [
	Vector2(-1,-1), Vector2(0,-1), Vector2(1,-1), 
	Vector2(-1, 0), Vector2(0, 0), Vector2(1, 0), 
	Vector2(-1, 1), Vector2(0, 1), Vector2(1, 1)
]

var tempWorkshop = null

func place(newWorkshop):
	if (!newWorkshop.place()):
		return false
	var pos = newWorkshop.position / 16
	orderManager.placeWorkshop(Utils.worldToMapPosition(pos), newWorkshop)
	return true

func create(index):
	tempWorkshop = workshopScene.instance()
	tempWorkshop.init(index)
	add_child(tempWorkshop)
	return tempWorkshop
