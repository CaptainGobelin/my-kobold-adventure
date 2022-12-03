extends Node

class PathNode:
	var x : int
	var y : int
	var h : int
	var cost : int
	var prev : PathNode
	func _init(newX, newY, newCost):
		self.x = newX
		self.y = newY
		self.cost = newCost

func findPath(start: Vector2, end: Vector2, map: TileMap, terrain: TileMap, floors: TileMap, nextTo: float):
	if (isInvalidPoint(start, map, terrain, true) || isInvalidPoint(end, map, terrain, nextTo>0)):
		return []
	var openList = {0: [PathNode.new(start.x, start.y, 0)]}
	var lockedNodes = []
	lockedNodes.resize(Const.MAP_SIZE * Const.MAP_SIZE)
	lockedNodes.fill(1000000)
	var currentNode = takeShortest(openList, lockedNodes)
	while (computeDistance(Vector2(currentNode.x, currentNode.y), end) > nextTo):
		addNeighbours(currentNode, end, openList, lockedNodes, map, terrain, floors)
		if (openList.keys().size() == 0):
			return []
		currentNode = takeShortest(openList, lockedNodes)
	return retrievePath(currentNode)

func retrievePath(node: PathNode):
	var result = [Vector2(node.x, node.y)]
	while (node.prev != null):
		node = node.prev
		result.push_back(Vector2(node.x, node.y))
	return result

func takeShortest(list: Dictionary, lockedNodes: Array):
	var key = list.keys().min()
	var result = list[key].pop_back()
	if list[key].size() == 0:
		list.erase(key)
	lockedNodes[result.x + Const.MAP_SIZE * result.y] = -1
	return result

func computeDistance(a: Vector2, b: Vector2):
	return floor(sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2)))

func addNeighbours(node: PathNode,end: Vector2, list: Dictionary, lockedNodes: Array,
map: TileMap, terrain: TileMap, floors: TileMap):
	var directions = [Vector3(-1, 0, 1), Vector3(1, 0, 1), Vector3(0, -1, 1), Vector3(0, 1, 1),
		Vector3(-1, -1, 1.4), Vector3(-1, 1, 1.4), Vector3(1, -1, 1.4), Vector3(1, 1, 1.4)]
	for n in directions:
		var x = node.x + n.x
		var y = node.y + n.y
		if (isInvalidPoint(Vector2(x, y), map, terrain, false)):
			continue
		var mult = 5
		if (floors.get_cell(x, y) != TileMap.INVALID_CELL):
			mult = 2
		var newNode = PathNode.new(x, y, node.cost + mult * n.z)
		newNode.h = newNode.cost + computeDistance(Vector2(newNode.x, newNode.y), end)
		newNode.prev = node
		if (lockedNodes[x + Const.MAP_SIZE * y] <= newNode.cost):
			continue
		lockedNodes[x + Const.MAP_SIZE * y] = newNode.cost
		if (list.has(newNode.h)):
			list[newNode.h].append(newNode)
		else:
			list[newNode.h] = [newNode]

func isInvalidPoint(point: Vector2, map: TileMap, terrain: TileMap, nextTo: bool):
	if (isOutOfBound(point)):
		return true
	if (map.get_cell(point.x, point.y) == TileMap.INVALID_CELL):
		return true
	if (nextTo):
		return false
	if (terrain.get_cell(point.x, point.y) != TileMap.INVALID_CELL):
		return true
	if (map.isBlocked[point.x][point.y]):
		return true
	return false

func isOutOfBound(point: Vector2):
	if (point.x < 0 || point.y < 0):
			return true
	if (point.x >= Const.MAP_SIZE || point.y >= Const.MAP_SIZE):
		return true
	return false

func worldToMapPosition(point: Vector2):
	return Vector2(floor(point.x/16), floor(point.y/16))

func init2DArray(size: int, defaultValue):
	var result = []
	result.resize(size)
	for i in range(0, size):
		result[i] = []
		result[i].resize(size)
		result[i].fill(defaultValue)
	return result
