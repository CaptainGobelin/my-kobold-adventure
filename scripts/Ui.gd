extends Control

enum STATES {
	MAIN_ACTION,
	BUILD_ACTION,
	BUILD_ACTION_FURNITURE,
	BUILD_ACTION_WORKSHOP,
	BUILD_ACTION_STRUCTURE,
	GATHER_ACTION,
	ZONE_ACTION,
	WORKSHOP_ACTION,
	WIP_ACTION,
	FURNITURE_ACTION,
	STOCKPILE_ACTION,
	FARMLAND_ACTION
}

enum LIST_DISPLAYS {
	NOTHING,
	FURNITURES,
	WORKSHOPS,
	WORKSHOP_TASKS
}

var actionMenus = {
	STATES.MAIN_ACTION: [
		SquareButton.TYPES.BUILD, 	SquareButton.TYPES.GATHER, 	SquareButton.TYPES.ZONE,
		SquareButton.TYPES.NONE, 	SquareButton.TYPES.NONE, 	SquareButton.TYPES.NONE,
		SquareButton.TYPES.NONE, 	SquareButton.TYPES.NONE, 	SquareButton.TYPES.NONE ],
	STATES.WORKSHOP_ACTION: [
		SquareButton.TYPES.NONE, 	SquareButton.TYPES.NONE, 	SquareButton.TYPES.NONE,
		SquareButton.TYPES.TASK, 	SquareButton.TYPES.NONE, 	SquareButton.TYPES.NONE,
		SquareButton.TYPES.NONE, 	SquareButton.TYPES.NONE, 	SquareButton.TYPES.RETURN ],
	STATES.BUILD_ACTION: [
		SquareButton.TYPES.BUILD_WORKSHOP,SquareButton.TYPES.BUILD_FURNITURE,SquareButton.TYPES.BUILD_STRUCTURE,
		SquareButton.TYPES.NONE, 	SquareButton.TYPES.NONE, 	SquareButton.TYPES.NONE,
		SquareButton.TYPES.NONE, 	SquareButton.TYPES.NONE, 	SquareButton.TYPES.RETURN ],
	STATES.ZONE_ACTION: [
		SquareButton.TYPES.ZONE_STOCKPILE, 	SquareButton.TYPES.ZONE_FARMLAND, 	SquareButton.TYPES.NONE,
		SquareButton.TYPES.NONE, 	SquareButton.TYPES.NONE, 	SquareButton.TYPES.NONE,
		SquareButton.TYPES.NONE, 	SquareButton.TYPES.NONE, 	SquareButton.TYPES.RETURN ]
}

onready var game = get_node("..")
onready var orderManager = game.get_node("OrderManager")
onready var mouseManager = game.get_node("MouseManager")
onready var furnitureManager = game.get_node("FurnitureManager")
onready var workshopManager = game.get_node("WorkshopManager")
onready var zoneManager = game.get_node("ZoneManager")
onready var stockpileManager = game.get_node("StockpileManager")
onready var actionMenu = get_node("ActionMenu")
onready var itemList = get_node("ActionMenu/ItemList")
onready var mainActionMenu = actionMenu.get_node("MainMenu")

var state = STATES.MAIN_ACTION
var currentList = LIST_DISPLAYS.NOTHING
var currentWorkshop = null

func _ready():
	actionMenu.displayMainActionMenu()
	set_process_input(true)
	set_process_unhandled_input(true)

func _input(event):
	match state:
		STATES.MAIN_ACTION:
			if (event.is_action_released("build")):
				actionMenu.displayBuildActionMenu()
			elif (event.is_action_released("zones")):
				actionMenu.displayZonesActionMenu()
		STATES.WORKSHOP_ACTION:
			if (event.is_action_released("createTask")):
				actionMenu.showTaskList()
		STATES.BUILD_ACTION:
			if (event.is_action_released("furniture")):
				state = STATES.BUILD_ACTION_FURNITURE
				actionMenu.displayItemList(LIST_DISPLAYS.FURNITURES)
			elif (event.is_action_released("workshop")):
				state = STATES.BUILD_ACTION_WORKSHOP
				actionMenu.displayItemList(LIST_DISPLAYS.WORKSHOPS)
		STATES.BUILD_ACTION_FURNITURE:
			if (event is InputEventKey && !event.is_pressed()):
				if (Data.FURNITURE_KEYS.has(event.get_scancode())):
					var index = Data.FURNITURE_KEYS[event.get_scancode()]
					mouseManager.placeThing(furnitureManager.create(index))
		STATES.BUILD_ACTION_WORKSHOP:
			if (event is InputEventKey && !event.is_pressed()):
				if (Data.WORKSHOP_KEYS.has(event.get_scancode())):
					var index = Data.WORKSHOP_KEYS[event.get_scancode()]
					mouseManager.placeThing(workshopManager.create(index))
		STATES.ZONE_ACTION:
			if (event.is_action_released("sotckpiles")):
				state = STATES.STOCKPILE_ACTION
				zoneManager.enable()
			elif (event.is_action_released("farmland")):
				pass

func _unhandled_input(event):
	if (event is InputEventMouseButton && !event.is_pressed()):
		actionMenu.displayMainActionMenu()

func _on_ItemList_item_selected(index):
	match currentList:
		LIST_DISPLAYS.NOTHING:
			actionMenu.displayMainActionMenu()
			return
		LIST_DISPLAYS.FURNITURES:
			mouseManager.placeThing(furnitureManager.create(index))
		LIST_DISPLAYS.WORKSHOPS:
			mouseManager.placeThing(workshopManager.create(index))
		LIST_DISPLAYS.WORKSHOP_TASKS:
			var task = Data.WORKSHOPS[currentWorkshop.type][3][index]
			orderManager.createItem(currentWorkshop.position, task)

func _on_button_click(button):
	match button.ButtonType:
		SquareButton.TYPES.RETURN:
			actionMenu.displayMainActionMenu()
		SquareButton.TYPES.BUILD:
			actionMenu.displayBuildActionMenu()
		SquareButton.TYPES.BUILD_FURNITURE:
			state = STATES.BUILD_ACTION_FURNITURE
			actionMenu.displayItemList(LIST_DISPLAYS.FURNITURES)
		SquareButton.TYPES.BUILD_WORKSHOP:
			state = STATES.BUILD_ACTION_WORKSHOP
			actionMenu.displayItemList(LIST_DISPLAYS.WORKSHOPS)
		SquareButton.TYPES.ZONE:
			actionMenu.displayZonesActionMenu()
		SquareButton.TYPES.ZONE_STOCKPILE:
			state = STATES.STOCKPILE_ACTION
			zoneManager.enable()
		SquareButton.TYPES.TASK:
			actionMenu.showTaskList()


func _on_ZoneManager_zoneCompleted(tiles):
	match state:
		STATES.STOCKPILE_ACTION:
			stockpileManager.createStockpile(tiles)
