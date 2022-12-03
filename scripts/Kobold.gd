extends Node2D

onready var game = get_node("../..")
onready var orderManager = game.get_node("OrderManager")
onready var itemManager = game.get_node("ItemManager")
onready var map = game.get_node("Map")
onready var terrain = map.get_node("Terrain")
onready var floors = map.get_node("Floors")

var occupation = "idle"
var triggerTimer = 0.0
var pathToFollow = []
var order: Classes.Order
var targetItem
var bringedItem
var carriedItem = -1

func _ready():
	set_process(true)

func _process(delta):
	triggerTimer += delta
	if (triggerTimer <= Const.REACTION_TIME[occupation]):
		return
	triggerTimer -= Const.REACTION_TIME[occupation]
	act()

func act():
	if (occupation == "idle"):
		takeOrder()
	match occupation:
		"execute":
			executeOrder()
		"move":
			nextMove()

func nextMove():
	if (pathToFollow.size() == 0):
		order = order.next
		if (order != null):
			occupation = "execute"
		else:
			occupation = "idle"
		return
	var oldPosition = position
	position = pathToFollow.pop_back() * 16
	if (oldPosition.x < position.x):
		$Sprite.flip_h = false
	elif (position.x < oldPosition.x):
		$Sprite.flip_h = true

func takeOrder():
	order = orderManager.openOrders.pop_front()
	if (order != null):
		occupation = "execute"

func executeOrder():
	if (order == null):
		occupation = "idle"
		return
	order.print()
	match order.what:
		"goTo":
			goTo(order.where)
		"goNextTo":
			goNextTo(order.where)
		"placeFurniture":
			buildFurniture()
		"placeWorkshop":
			buildWorkshop()
		"bring":
			bring(order.where, order.ref)
		"fetchItem":
			fetchItem(order.ref)
		"gather":
			gather(order.ref)
		"createItem":
			createItem()
		"store":
			storeItem()

func createItem():
	itemManager.spawnItem(order.where, order.ref)
	order = null
	occupation = "idle"

func buildFurniture():
	if (order == null || order.ref == null || !order.ref.has_method("build")):
		cancelOrder()
		return
	if (Utils.computeDistance(Utils.worldToMapPosition(position), Utils.worldToMapPosition(order.ref.position)) >= 2):
		var goNextToOrder = orderManager.goNextToOrder(Utils.worldToMapPosition(order.ref.position))
		goNextToOrder.pushBack(order)
		order = goNextToOrder
		return
	order.ref.build()
	order = null
	occupation = "idle"

func buildWorkshop():
	if (order == null || order.ref == null || !order.ref.has_method("build")):
		cancelOrder()
		return
	if (Utils.computeDistance(Utils.worldToMapPosition(position), Utils.worldToMapPosition(order.ref.position)) >= 1):
		var goToOrder = orderManager.goToOrder(Utils.worldToMapPosition(order.ref.position))
		goToOrder.pushBack(order)
		order = goToOrder
		return
	order.ref.build()
	order = null
	occupation = "idle"

func gather(ressource: Object):
	if (ressource == null):
		order = null
		return
	if (Utils.computeDistance(Utils.worldToMapPosition(position), Utils.worldToMapPosition(ressource.position)) >= 2):
		var goNextToOrder = orderManager.goNextToOrder(Utils.worldToMapPosition(ressource.position))
		goNextToOrder.pushBack(order)
		order = goNextToOrder
		return
	itemManager.spawnItem(ressource.position)
	ressource.queue_free()
	order = order.next

func bring(pos: Vector2, what):
	if (carriedItem == -1):
		var itemId = itemManager.getByTags(what, true, self)
		if (itemId == null):
			cancelOrder()
			return
		var newOrder = orderManager.fetchItemOrder(itemId)
		newOrder.pushBack(order)
		order = newOrder
		return
	if (Utils.computeDistance(Utils.worldToMapPosition(position), pos) >= 2):
		var newOrder = orderManager.goNextToOrder(pos)
		newOrder.pushBack(order)
		order = newOrder
		return
	consumeCarriedItem()
	order = order.next

func fetchItem(itemId: int):
	if (!itemManager.checkId(itemId)):
		cancelOrder()
		return
	var itemPos = itemManager.getById(itemId)[Data.ITEMS_ATTR.Position]
	if (Utils.worldToMapPosition(position) != itemPos):
		var goToOrder = orderManager.goToOrder(itemPos)
		goToOrder.pushBack(order)
		order = goToOrder
		return
	if (pickupItem(itemId)):
		order = order.next
	else:
		cancelOrder()

func findPath(pos: Vector2, distance: float):
	return Utils.findPath(position/16, pos, map, terrain, floors, distance)

func goTo(pos: Vector2):
	pathToFollow = Utils.findPath(position/16, pos, map, terrain, floors, 0)
	if (pathToFollow.size() == 0):
		cancelOrder()
		return
	occupation = "move"

func goNextTo(pos: Vector2):
	pathToFollow = Utils.findPath(position/16, pos, map, terrain, floors, 1.9)
	if (pathToFollow.size() == 0):
		cancelOrder()
		return
	occupation = "move"

func cancelOrder():
	occupation = "idle"
	if (order == null):
		return
	orderManager.openOrders.push_back(order)
	order = null

func pickupItem(id: int):
	if (!itemManager.isAvailable(id)):
		return false
	itemManager.takeItem(id, get_instance_id())
	carriedItem = id
	return true

func throwCarriedItem():
	itemManager.throwItem(carriedItem, Utils.worldToMapPosition(position))
	carriedItem = -1

func consumeCarriedItem():
	itemManager.delete(carriedItem)
	carriedItem = -1

func storeItem():
	var itemId = order.ref[0]
	if (carriedItem == itemId):
		if (Utils.worldToMapPosition(position) != order.where):
			var goToOrder = orderManager.goToOrder(order.where)
			goToOrder.pushBack(order)
			order = goToOrder
		else:
			throwCarriedItem()
			order = order.next
	else:
		var itemPos = itemManager.items[itemId][Data.ITEMS_ATTR.Position]
		if (Utils.worldToMapPosition(position) != itemPos):
			var goToOrder = orderManager.goToOrder(itemPos)
			goToOrder.pushBack(order)
			order = goToOrder
		else:
			pickupItem(itemId)
