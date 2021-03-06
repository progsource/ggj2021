extends Reference

var player_obj = null

func init():
	GLOBAL.event_bus.connect("follow_set", self, "_on_follow_set")
	GLOBAL.event_bus.connect("fifo_pop", self, "_on_fifo_pop")

func _on_follow_set(pet_actor) -> void:
	GLOBAL.follow_chain.push_back(pet_actor)
	for chain_item in GLOBAL.follow_chain.get_item_list():
		var target = chain_item.prev.obj if chain_item.prev else player_obj
		GLOBAL.event_bus.emit_signal("follow_chain", chain_item.obj, target)
		
func _on_fifo_pop() -> void:
	if GLOBAL.follow_chain.get_item_list():
		var chain_item = GLOBAL.follow_chain.get_item_list()[0]
		GLOBAL.event_bus.emit_signal("follow_chain", chain_item.obj, player_obj)
