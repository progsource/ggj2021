extends Reference

var head = null
var tail = null

class Item:
	var prev = null
	var next = null
	var obj = null

func push_back(obj) -> void :
	var item = Item.new()
	item.obj = obj

	if head == null && tail == null:
		head = item
		tail = item
		return

	tail.next = item
	item.prev = tail

	tail = item

func pop():
	if head == null:
		return null

	var o = head.obj
	head = head.next
	head.prev = null
	return o
