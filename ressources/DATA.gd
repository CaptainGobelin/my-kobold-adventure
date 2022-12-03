extends Node

enum ENTITY_TYPES {
	FURNITURE, WORKSHOP, ITEM
}

enum FURNITURE_TYPES {
	Chair, Table, Bed, Barrel, Crate, Chest
}

enum WORKSHOP_TYPES {
	Carpenter, Mason
}

enum ITEM_TYPES {
	Wood, Stone, Chair, Table, Bed, Barrel, Crate, Chest
}


enum ITEM_TAGS {
	# Ressources
	Ressource,
		WoodLog, Stone,
	# Furnitures
	Furniture,
		Bed, Chair, Table, Barrel, Crate, Chest,
	# Materials general
	Mat_Wood,
	Mat_Stone
}


# Name Sprite Shortcut
const FURNITURES = {
	FURNITURE_TYPES.Chair: 	["Chair", 1, "c"],
	FURNITURE_TYPES.Table: 	["Table", 0, "t"],
	FURNITURE_TYPES.Bed: 	["Bed", 2, "b"],
	FURNITURE_TYPES.Barrel: ["Barrel", 3, "v"],
	FURNITURE_TYPES.Crate: 	["Crate", 4, "n"],
	FURNITURE_TYPES.Chest: 	["Chest", 5, "r"]
}

# Name Sprite Shortcut Tasks
const WORKSHOPS = {
	WORKSHOP_TYPES.Carpenter: 
		["Carpenter", 0, "c", 
			[
				ITEM_TYPES.Chair, ITEM_TYPES.Table, ITEM_TYPES.Barrel,
				ITEM_TYPES.Bed, ITEM_TYPES.Crate, ITEM_TYPES.Chest
			]
		],
	WORKSHOP_TYPES.Mason: 
		["Mason", 1, "m", 
			[
				ITEM_TYPES.Chair, ITEM_TYPES.Table, ITEM_TYPES.Chest
			]
		]
}

enum ITEMS_ATTR {Name, Tile, Shortcut, Tags, Available, Stored, Position, Index}
const ITEMS = {
	ITEM_TYPES.Wood: 	["Wood", Vector2(1, 4), "", 
		[ITEM_TAGS.Ressource, ITEM_TAGS.WoodLog]
	],
	ITEM_TYPES.Stone: 	["Stone", Vector2(0, 4), "",
		[ITEM_TAGS.Ressource, ITEM_TAGS.Stone]
	],
	ITEM_TYPES.Chair: 	["Chair", Vector2(1, 0), "c",
		[ITEM_TAGS.Furniture, ITEM_TAGS.Chair]
	],
	ITEM_TYPES.Table: 	["Table", Vector2(0, 0), "t",
		[ITEM_TAGS.Furniture, ITEM_TAGS.Table]
	],
	ITEM_TYPES.Bed: 	["Bed", Vector2(2, 0), "b",
		[ITEM_TAGS.Furniture, ITEM_TAGS.Bed]
	],
	ITEM_TYPES.Barrel: 	["Barrel", Vector2(3, 0), "v",
		[ITEM_TAGS.Furniture, ITEM_TAGS.Barrel]
	],
	ITEM_TYPES.Crate: 	["Crate", Vector2(4, 0), "n",
		[ITEM_TAGS.Furniture, ITEM_TAGS.Crate]
	],
	ITEM_TYPES.Chest: 	["Chest", Vector2(5, 0), "r",
		[ITEM_TAGS.Furniture, ITEM_TAGS.Chest]
	]
}

const FURNITURE_KEYS = {
	KEY_C: FURNITURE_TYPES.Chair,
	KEY_T: FURNITURE_TYPES.Table,
	KEY_B: FURNITURE_TYPES.Bed,
	KEY_V: FURNITURE_TYPES.Barrel,
	KEY_N: FURNITURE_TYPES.Crate,
	KEY_R: FURNITURE_TYPES.Chest
}

const WORKSHOP_KEYS = {
	KEY_C: WORKSHOP_TYPES.Carpenter,
	KEY_M: WORKSHOP_TYPES.Mason
}

