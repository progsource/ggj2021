extends Reference

var poster_packed = load("res://scenes/Wanted.tscn")

func create_poster(pet_type : int, pos : Vector2) -> Object:
	var instance = poster_packed.instance()

	instance.set_pet(pet_type)
	instance.position = pos
	instance.add_to_group("poster")

	return instance
