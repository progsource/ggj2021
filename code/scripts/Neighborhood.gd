extends Node2D

func _ready():
	GLOBAL.astar_tilemap_connector.debug_node = $DebugNavi
	GLOBAL.astar_tilemap_connector.generate_vertices($Navi, [0])
	$DebugNavi.visible = GLOBAL.DEBUG
	if GLOBAL.DEBUG:
		GLOBAL.astar_tilemap_connector.draw_debug()
	$Navi.visible = GLOBAL.DEBUG
	
	var player = GLOBAL.actor_factory.create_berry(GLOBAL.is_char_female, Vector2(0, 0))
	$player.add_child(player)
	
	var poster_spots = $PosterContainer.get_children()
	var pet_spots = $PetContainer.get_children()
	GLOBAL.game_data.pets = pet_spots.size()
	for c in pet_spots:
		var pt = GLOBAL.pet_type_object_pool.get_random_pet_type()
		if pt == -1:
			break
		c.pet_type = pt
		var pos = c.get_position() + Vector2(8, 8)
		var pet = GLOBAL.actor_factory.create_pet(pt, pos)
		if poster_spots.size() == 0:
			return
		var poster = GLOBAL.poster_factory.create_poster(pt, poster_spots.pop_front().get_position())
		if poster == null:
			return
		$objects.add_child(pet)
		$objects.add_child(poster)
