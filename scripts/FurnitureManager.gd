extends Node

onready var game = get_node("..")
onready var map = game.get_node("Map")
onready var orderManager = game.get_node("OrderManager")

onready var furnitureScene = load("res://scenes/Furniture.tscn")

var tempFurniture = null

func place(newFurniture):
	if (!newFurniture.place()):
		return false
	var pos = newFurniture.position
	orderManager.placeFurniture(Utils.worldToMapPosition(pos), newFurniture)
	return true

func create(index):
	tempFurniture = furnitureScene.instance()
	tempFurniture.init(index)
	add_child(tempFurniture)
	return tempFurniture
