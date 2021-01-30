extends Node2D




func _ready():
	var player = GLOBAL.actor_factory.create_berry(GLOBAL.is_char_female, Vector2(0, 0))
	$player.add_child(player)
	
	for c in $PetContainer.get_children():
		var pt = GLOBAL.pet_type_object_pool.get_random_pet_type()
		if pt == -1:
			break
		c.pet_type = pt
		var pos = c.get_position() + Vector2(8, 8)
		var pet = GLOBAL.actor_factory.create_pet(pt, pos)
		$objects.add_child(pet)
