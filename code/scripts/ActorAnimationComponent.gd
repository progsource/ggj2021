extends "res://scripts/ActorComponent.gd"

var last_direction : Vector2

func process(_delta) -> void :
	if actor.velocity != Vector2.ZERO:
		last_direction = 0.5 * last_direction + 0.5 * actor.direction
		var animation_name = _get_animation_direction(last_direction)
		actor.play_animation(animation_name)
	else:
		var animation_name = "idle"
		actor.play_animation(animation_name)

func _get_animation_direction(direction: Vector2) -> String :
	var norm_direction = direction.normalized()
	if norm_direction.y >= 0.707:
		return "down"
	elif norm_direction.y <= -0.707:
		return "up"
	elif norm_direction.x <= -0.707:
		return "left"
	elif norm_direction.x >= 0.707:
		return "right"
	return "down"
