extends Node

onready var game = get_node("..")
onready var itemManager = game.get_node("ItemManager")
onready var sceneryManager = game.get_node("SceneryManager")

var openOrders = []

func _ready():
	set_process_input(false)

func _input(event):
	if (event.is_action_released("gather")):
		var mapPos = Utils.worldToMapPosition(get_viewport().get_mouse_position())
		for s in sceneryManager.get_children():
			var sPos = Utils.worldToMapPosition(s.position)
			if (sPos.x == mapPos.x && sPos.y == mapPos.y):
				openOrders.push_back(gatherOrder(s))

func goToOrder(pos: Vector2):
	return Classes.Order.new("goTo", pos, "all")

func goNextToOrder(pos: Vector2):
	return Classes.Order.new("goNextTo", pos, "all")

func fetchItemOrder(itemId: int):
	var item = itemManager.getById(itemId)
	var itemPosition = item[Data.ITEMS_ATTR.Position]
	var goToOrder = Classes.Order.new("goTo", itemPosition, "all")
	var takeItemOrder = Classes.Order.new("fetchItem", itemPosition, "all")
	takeItemOrder.ref = itemId
	goToOrder.next = takeItemOrder
	return goToOrder

func placeFurniture(pos: Vector2, furniture: Object):
	var order = Classes.Order.new("bring", pos, "all")
	order.ref = [Data.ITEM_TAGS.WoodLog]
	order.next = Classes.Order.new("placeFurniture", pos, "same")
	order.next.ref = furniture
	openOrders.push_back(order)

func placeWorkshop(pos: Vector2, workshop: Object):
	var order = Classes.Order.new("placeWorkshop", pos, "all")
	order.ref = workshop
	openOrders.push_back(order)

func gatherOrder(ressource: Object):
	if (ressource == null):
		return null
	var order = Classes.Order.new("gather", Utils.worldToMapPosition(ressource.position), "all")
	order.ref = ressource
	return order

func createItem(pos: Vector2, itemIndex):
	var mapPos = Utils.worldToMapPosition(pos)
	var order = Classes.Order.new("bring", mapPos, "all")
	order.ref = "wood"
	order.next = Classes.Order.new("createItem", mapPos, "same")
	order.next.ref = itemIndex
	openOrders.push_back(order)

func storeItem(itemId: int, stockpileId: int, pos: Vector2):
	var order = Classes.Order.new("store", pos, "all")
	order.ref = [itemId, stockpileId]
	openOrders.push_back(order)
