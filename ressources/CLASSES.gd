extends Node

class Order:
	var what: String
	var where: Vector2
	var who: String
	var next: Order
	var ref
	func _init(order, pos, filter):
		self.what = order
		self.where = pos
		self.who = filter
	func print():
		print("Order: " + what + " at (" + String(where.x) + ", " + String(where.y) + ")")
	func pushBack(o: Order):
		if (next == null):
			next = o
			return
		var nextOrder = next
		while (nextOrder.next != null):
			nextOrder = nextOrder.next
		nextOrder.next = o
