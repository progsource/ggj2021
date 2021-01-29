extends Reference

var actor_packed = load("res://scenes/Pet.tscn")

func create_pet(pet_type : int, pos : Vector2) -> Object:
	var instance = actor_packed.instance()

	instance.add_component(load("res://scripts/ActorAnimationComponent.gd").new())
	instance.position = pos
	instance.get_node("Sprite").texture = load("res://assets/gfx/%s" % GLOBAL.PetImageMap[pet_type])
	instance.add_to_group("pets")

	return instance
