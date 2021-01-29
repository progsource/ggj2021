extends "res://scripts/ActorComponent.gd"

func physics_process(_delta) -> void :
	actor.move_and_slide(actor.velocity)
