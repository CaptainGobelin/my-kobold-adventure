extends TileMap

onready var menu = get_node("MainMenu")
onready var label = menu.get_node("Label")
onready var itemList = get_node("ItemList")
onready var ui = get_node("..")

func displayMainActionMenu():
	hideActionMenus()
	menu.visible = true
	ui.state = ui.STATES.MAIN_ACTION
	changeButtons(ui.state)

func displayWorkshopActionMenu(workshop):
	hideActionMenus()
	menu.visible = true
	label.visible = true
	label.text = Data.WORKSHOPS[workshop.type][0]
	ui.currentWorkshop = workshop
	ui.state = ui.STATES.WORKSHOP_ACTION
	changeButtons(ui.state)

func displayBuildActionMenu():
	hideActionMenus()
	menu.visible = true
	ui.state = ui.STATES.BUILD_ACTION
	changeButtons(ui.state)

func displayZonesActionMenu():
	hideActionMenus()
	menu.visible = true
	ui.state = ui.STATES.ZONE_ACTION
	changeButtons(ui.state)

func hideActionMenus():
	ui.currentList = ui.LIST_DISPLAYS.NOTHING
	ui.currentWorkshop = null
	for c in get_children():
		c.visible = false
	label.visible = false

func changeButtons(menuType):
	var buttons = menu.get_node("Buttons")
	for i in range(0, buttons.get_child_count()):
		buttons.get_child(i).changeType(ui.actionMenus[menuType][i])

func showTaskList():
	if (ui.currentWorkshop == null || ui.state != ui.STATES.WORKSHOP_ACTION):
		displayMainActionMenu()
		return
	ui.currentList = ui.LIST_DISPLAYS.WORKSHOP_TASKS
	itemList.clear()
	for task in Data.WORKSHOPS[ui.currentWorkshop.type][3]:
		var item = Data.ITEMS[task][2] + ": " + Data.ITEMS[task][0]
		itemList.add_item(item)
	itemList.visible = true

func displayItemList(list):
	itemList.clear()
	ui.currentList = list
	var items
	match list:
		ui.LIST_DISPLAYS.FURNITURES:
			items = Data.FURNITURES
		ui.LIST_DISPLAYS.WORKSHOPS:
			items = Data.WORKSHOPS
	for index in items.keys():
		itemList.add_item(items[index][2] + ": " + items[index][0])
	itemList.visible = true
