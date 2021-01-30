extends Reference


var astar : AStar2D = null


func init_astar():
	astar = AStar2D.new()


func generate_vertices(tilemap : TileMap, walkable_tile_types : Array):
	var nav_vertices := []
	var nav_connections := []

	var used_rect = tilemap.get_used_rect()

	for y in range(used_rect.size.y):
		for x in range(used_rect.size.x):
			var tile = tilemap.get_cell(x, y)
			if tile == TileMap.INVALID_CELL:
				continue
			if tile in walkable_tile_types:
				nav_vertices.push_back({"id": _get_index_for_xy(x, y, used_rect.size.x), "pos": Vector2(x, y)})

	astar.clear()
	for p in nav_vertices:
		var pos = p["pos"]
		pos.x = pos.x * 16 + 8
		pos.y = pos.y * 16 + 8
		astar.add_point(p["id"], pos)

	for y in range(used_rect.size.y):
		for x in range(used_rect.size.x):
			if tilemap.get_cell(x, y) == TileMap.INVALID_CELL:
				continue
			# x x x
			# x # 0
			# 0 0 0
			if y > 0:
				if x > 0:
					if (tilemap.get_cell(x - 1, y - 1) in walkable_tile_types and
						(tilemap.get_cell(x - 1, y) in walkable_tile_types or
						tilemap.get_cell(x, y - 1) in walkable_tile_types)
					):
						nav_connections.push_back({
							"id" : _get_index_for_xy(x, y, used_rect.size.x),
							"to_id" : _get_index_for_xy(x - 1, y - 1, used_rect.size.x)
							})

				if tilemap.get_cell(x, y - 1) in walkable_tile_types:
					nav_connections.push_back({
						"id" : _get_index_for_xy(x, y, used_rect.size.x),
						"to_id" : _get_index_for_xy(x, y - 1, used_rect.size.x)
						})

				if x < used_rect.size.x - 1:
					if (tilemap.get_cell(x + 1, y - 1) in walkable_tile_types and
						(tilemap.get_cell(x + 1, y) in walkable_tile_types or
						tilemap.get_cell(x, y - 1) in walkable_tile_types)
					):
						nav_connections.push_back({
							"id" : _get_index_for_xy(x, y, used_rect.size.x),
							"to_id" : _get_index_for_xy(x + 1, y - 1, used_rect.size.x)
							})

			if x > 0:
				if tilemap.get_cell(x - 1, y) in walkable_tile_types:
					nav_connections.push_back({
						"id" : _get_index_for_xy(x, y, used_rect.size.x),
						"to_id" : _get_index_for_xy(x - 1, y, used_rect.size.x)
						})

	for c in nav_connections:
		astar.connect_points(c["id"], c["to_id"])

func _get_index_for_xy(x : int, y : int, map_width : int) -> int :
	return y * map_width + x;
