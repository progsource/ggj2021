extends Area2D

onready var animation_player = $ActionDisplay/AnimationPlayer
onready var actor = get_parent()

func _ready():
	GLOBAL.event_bus.connect(
		"follow_set",
		self,
		"_on_follow_set"
	)

	# warning-ignore:return_value_discarded
	self.connect("body_entered", self, "_on_body_entered")
	# warning-ignore:return_value_discarded
	self.connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body):
	if "player" in body.get_groups():
		GLOBAL.event_bus.emit_signal("action_radius_entered", actor)
		animation_player.play("display")
		yield( animation_player, "animation_finished")
		animation_player.play("bob")

func _on_body_exited(body):
	if "player" in body.get_groups():
		GLOBAL.event_bus.emit_signal("action_radius_exited", actor)
		animation_player.stop()
		animation_player.play_backwards("display")

func _on_follow_set(pet_actor):
	if pet_actor == actor:
		GLOBAL.event_bus.disconnect("follow_set", self, "_on_follow_set")
		animation_player.play("init")
		self.disconnect("body_entered", self, "_on_body_entered")
		self.disconnect("body_exited", self, "_on_body_exited")
