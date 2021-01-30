extends "res://scripts/ActorComponent.gd"

var follow: KinematicBody2D = null

func physics_process(_delta) -> void :
	if not follow:
		return

	var direction: Vector2 = follow.direction

	# If input is digital, normalize it for diagonal movement
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()

	# Apply movement
	actor.direction = direction
	actor.velocity = actor.speed * direction# * _delta
