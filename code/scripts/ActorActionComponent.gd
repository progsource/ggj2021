extends "res://scripts/ActorComponent.gd"

func init() -> void :
	GLOBAL.chain_controller.player_obj = actor

func input(event) -> void :
	if event.is_action_pressed("action") && actor.get_slide_count() > 0:
		for i in actor.get_slide_count():
			var collision = actor.get_slide_collision(i)
			
			if collision.collider.get_groups().has("pets"):
				GLOBAL.event_bus.emit_signal(
					"follow_set",
					collision.collider
				)
