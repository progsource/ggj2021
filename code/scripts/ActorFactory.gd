extends Reference

var pet_packed = load("res://scenes/Pet.tscn")
var berry_packed = load("res://scenes/Berry.tscn")

func create_pet(pet_type : int, pos : Vector2) -> Object:
	var instance = pet_packed.instance()

	instance.add_component(load("res://scripts/ActorAnimationComponent.gd").new())
	instance.position = pos
	instance.get_node("Sprite").texture = load("res://assets/gfx/%s" % GLOBAL.PetImageMap[pet_type])
	instance.add_to_group("pets")

	return instance

func create_berry(is_female : bool, pos : Vector2) -> Object:
	var instance = berry_packed.instance()

	instance.add_component(load("res://scripts/ActorInputComponent.gd").new())
	instance.add_component(load("res://scripts/ActorPhysicsComponent.gd").new())
	instance.add_component(load("res://scripts/ActorAnimationComponent.gd").new())
	instance.position = pos
	if is_female:
		instance.get_node("Sprite").texture = load("res://assets/gfx/berry_fem.png")
	else:
		instance.get_node("Sprite").texture = load("res://assets/gfx/berry_guy.png")
	instance.add_to_group("player")

	return instance
