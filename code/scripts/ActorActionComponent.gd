extends "res://scripts/ActorComponent.gd"

func input(event) -> void :
	if event.is_action_pressed("action") && actor.get_slide_count() > 0:
		for i in actor.get_slide_count():
			var collision = actor.get_slide_collision(i)
			
			if collision.collider.get_groups().has("pets"):
				GLOBAL.event_bus.emit_signal(
					"follow_set",
					get_instance_id(),
					collision.collider.get_instance_id(),
					actor
				)
