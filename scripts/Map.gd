extends TileMap

onready var terrain = get_node("Terrain")

var isBlocked = []
var isTaken = []
var isChar = []

func _ready():
	isBlocked = Utils.init2DArray(Const.MAP_SIZE, false)
	isTaken = Utils.init2DArray(Const.MAP_SIZE, false)
	isChar = Utils.init2DArray(Const.MAP_SIZE, 0)
	for p in terrain.get_used_cells():
		isBlocked[p.x][p.y] = true
	set_process(false)

func _process(_delta):
	$Debug.clear()
	for i in range(0,Const.MAP_SIZE):
		for j in range(0,Const.MAP_SIZE):
			if (isTaken[i][j] || isBlocked[i][j]):
				$Debug.set_cell(i, j, 0)
