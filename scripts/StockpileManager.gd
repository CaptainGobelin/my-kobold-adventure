extends Node

onready var game = get_node("..")
onready var map = game.get_node("Map")
onready var itemManager = game.get_node("ItemManager")
onready var orderManager = game.get_node("OrderManager")
onready var tilemap = get_node("TileMap")


var nextId = 0
var stockpiles = {}
var freeSpace = {}
var triggerTimer = 0.0

func _ready():
	set_process(true)

func _process(delta):
	if (freeSpace.empty()):
		set_process(false)
		return
	triggerTimer += delta
	if (triggerTimer <= Const.REACTION_TIME["stockpile"]):
		return
	triggerTimer -= Const.REACTION_TIME["stockpile"]
	storeItems()

func createStockpile(tiles: Array):
	if (tiles.empty()):
		return
	for t in tiles:
		map.isTaken[t.x][t.y] = true
		tilemap.set_cell(t.x, t.y, 0)
	stockpiles[nextId] = [tiles, [Data.ITEM_TAGS.Ressource]]
	freeSpace[nextId] = [tiles.size(), tiles]
	set_process(true)
	nextId += 1

func findItemToStore(stockpileId: int):
	for itemId in itemManager.items.keys():
		if (itemManager.items[itemId][Data.ITEMS_ATTR.Available] != -1):
			continue
		if (itemManager.items[itemId][Data.ITEMS_ATTR.Stored] != -1):
			continue
		for tag in stockpiles[stockpileId][1]:
			if (itemManager.items[itemId][Data.ITEMS_ATTR.Tags].has(tag)):
				itemManager.items[itemId][Data.ITEMS_ATTR.Stored] = stockpileId
				orderManager.storeItem(itemId, stockpileId, freeSpace[stockpileId][1].pop_back())
				if (freeSpace[stockpileId][1].empty()):
					freeSpace.erase(stockpileId)
				else:
					freeSpace[stockpileId][0] -= 1
				return true
	return false

func storeItems():
	for stockpileId in freeSpace.keys():
		for i in range(0, freeSpace[stockpileId][0]):
			var foundItem = findItemToStore(stockpileId)
			if (!foundItem):
				return
