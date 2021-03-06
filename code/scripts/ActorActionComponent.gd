extends "res://scripts/ActorComponent.gd"

var nearest_actions = []

func init() -> void :
	GLOBAL.chain_controller.player_obj = actor
	GLOBAL.event_bus.connect("action_radius_exited", self, "_on_action_radius_exited")
	GLOBAL.event_bus.connect("action_radius_entered", self, "_on_action_radius_entered")

func input(_event) -> void :
	if Input.is_action_just_pressed("action") && nearest_actions.size() > 0:
		_pickup_action()
		_deliver_action()

func _pickup_action():
	for pet in nearest_actions:
		if "pets" in pet.get_groups():
			GLOBAL.event_bus.emit_signal(
				"follow_set",
				pet
			)
			nearest_actions.erase(pet)
			return

func _deliver_action():
	for poster in nearest_actions:
		if "poster" in poster.get_groups():
			GLOBAL.event_bus.emit_signal(
				"follow_release",
				GLOBAL.follow_chain.pop(),
				poster
			)
			return

func _on_action_radius_exited(action_object):
	if nearest_actions.has(action_object):
		nearest_actions.erase(action_object)

func _on_action_radius_entered(action_object):
	if not nearest_actions.has(action_object):
		nearest_actions.push_back(action_object)
