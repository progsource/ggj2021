extends Node2D


func _ready():
	var pet = GLOBAL.actor_factory.create_pet(GLOBAL.PetType.Dog0, Vector2(0,48))
	$objects.add_child(pet)
