extends Reference

var head = null
var tail = null

class Item:
	var prev = null
	var next = null
	var obj = null

func push_back(obj) -> void :
	var i = head
	while i != null:
		if i.obj == obj:
			return
		i = i.next
	
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
	if head != null:
		head.prev = null
	return o

func get_item_list() -> Array:
	var list := []

	var i = head

	while true:
		list.append(i)
		if i.next == null:
			break
		i = i.next

	return list
