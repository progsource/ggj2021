extends Node2D


func _ready():
	var player = GLOBAL.actor_factory.create_berry(GLOBAL.is_char_female, Vector2(0, 0))
	$player.add_child(player)
	
	for c in $PetContainer.get_children():
		var r = GLOBAL.rng.randi_range(0, GLOBAL.PetType.COUNT - 1)
		c.pet_type = r
		var pos = c.get_position() + Vector2(8, 8)
		var pet = GLOBAL.actor_factory.create_pet(r, pos)
		$objects.add_child(pet)
