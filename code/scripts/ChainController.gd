extends Reference

var player_obj = null

func init():
	GLOBAL.event_bus.connect("follow_set", self, "_on_follow_set")

func _on_follow_set(pet_actor) -> void:
	GLOBAL.follow_chain.push_back(pet_actor)
	
	for chain_item in GLOBAL.follow_chain.get_item_list():
		GLOBAL.event_bus.emit_signal("follow_chain", chain_item.obj, chain_item.prev.obj if chain_item.prev else player_obj)
