extends Node

onready var game = get_node("..")
onready var itemScene = load("res://scenes/Item.tscn")

var items = {}
var itemsByPos = {}
var nextId = 0

func _ready():
	spawnItem(Vector2(37, 0), 0)
	spawnItem(Vector2(38, 0), 0)
	spawnItem(Vector2(37, 2), 1)
	spawnItem(Vector2(38, 2), 1)

func checkId(id: int):
	return items.has(id)

func delete(id: int):
	if (!checkId(id)):
		return
	var posString = String(items[id][Data.ITEMS_ATTR.Position])
	if (itemsByPos.has(posString) && itemsByPos[posString].has(id)):
		itemsByPos[posString].erase(id)
		if (itemsByPos[posString].empty()):
			itemsByPos.erase(posString)
		updateTile(items[id][Data.ITEMS_ATTR.Position])
	items.erase(id)

func getById(id: int):
	if (!checkId(id)):
		return null
	return items[id]

func getByTags(tags: Array, reachable: bool = false, who: Object = null):
	for id in items.keys():
		var ok = true
		for tag in tags:
			if (!items[id][Data.ITEMS_ATTR.Tags].has(tag)):
				ok = false
		if (!ok):
			continue
		if (reachable && who != null):
			if (who.findPath(items[id][Data.ITEMS_ATTR.Position], 0).size() > 0):
				return id
		else:
			return id
	return null

func isAvailable(id: int):
	if (!checkId(id)):
		return false
	return (items[id][Data.ITEMS_ATTR.Available] == -1)

func spawnItem(pos: Vector2, index):
	var itemData = Data.ITEMS[index] + [-1, -1, pos, index]
	items[nextId] = itemData
	var posString = String(pos)
	if (itemsByPos.has(posString)):
		itemsByPos[posString].push_back(nextId)
	else:
		itemsByPos[posString] = [nextId]
		updateTile(pos)
	nextId += 1

func takeItem(id: int, entityId: int):
	if (!checkId(id)):
		return
	items[id][Data.ITEMS_ATTR.Available] = entityId
	var posString = String(items[id][Data.ITEMS_ATTR.Position])
	itemsByPos[posString].erase(id)
	if (itemsByPos[posString].empty()):
		itemsByPos.erase(posString)
	updateTile(items[id][Data.ITEMS_ATTR.Position])

func throwItem(id: int, pos: Vector2):
	if (!checkId(id)):
		return
	items[id][Data.ITEMS_ATTR.Available] = -1
	items[id][Data.ITEMS_ATTR.Position] = pos
	var posString = String(pos)
	if (itemsByPos.has(posString)):
		itemsByPos[posString].push_back(id)
	else:
		itemsByPos[posString] = [id]
		updateTile(items[id][Data.ITEMS_ATTR.Position])

func updateTile(pos: Vector2):
	var posString = String(pos)
	if (!itemsByPos.has(posString)):
		$TileMap.set_cellv(pos, TileMap.INVALID_CELL)
		return
	var id = itemsByPos[posString][0]
	if (!checkId(id)):
		$TileMap.set_cellv(pos, TileMap.INVALID_CELL)
		return
	$TileMap.set_cellv(pos, 0, false, false, false, items[id][Data.ITEMS_ATTR.Tile])
