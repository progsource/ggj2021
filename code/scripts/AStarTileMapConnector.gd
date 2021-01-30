extends Reference


var astar : AStar2D = null
var debug_node : Node2D = null
var debug_connection_size : int = 0


func init_astar():
	astar = AStar2D.new()


func generate_vertices(tilemap : TileMap, walkable_tile_types : Array):
	var nav_vertices := []
	var nav_connections := []
	debug_connection_size = 0

	var used_rect = tilemap.get_used_rect()
	print("used rect pos: %d:%d" % [used_rect.position.x, used_rect.position.y])

	for y in range(used_rect.position.y, used_rect.size.y):
		for x in range(used_rect.position.x, used_rect.size.x):
			var tile = tilemap.get_cell(x, y)
			if tile == TileMap.INVALID_CELL:
				continue
			if tile in walkable_tile_types:
				nav_vertices.push_back({"id": _get_index_for_xy(x, y, used_rect), "pos": Vector2(x, y)})

	astar.clear()
	for p in nav_vertices:
		var pos = p["pos"]
		pos.x = used_rect.position.x + (pos.x * 16) + 8 + 16
		pos.y = used_rect.position.y + (pos.y * 16) + 8 + 16
		astar.add_point(p["id"], pos)
	
	assert(astar.get_points().size() == nav_vertices.size())

	for y in range(used_rect.position.y, used_rect.size.y):
		for x in range(used_rect.position.x, used_rect.size.x):
			if tilemap.get_cell(x, y) == TileMap.INVALID_CELL:
				continue
			# x x x
			# x # 0
			# 0 0 0
			if (tilemap.get_cell(x - 1, y - 1) in walkable_tile_types and
				(tilemap.get_cell(x - 1, y) in walkable_tile_types or
				tilemap.get_cell(x, y - 1) in walkable_tile_types)
			):
				nav_connections.push_back({
					"id" : _get_index_for_xy(x, y, used_rect),
					"to_id" : _get_index_for_xy(x - 1, y - 1, used_rect)
					})

			if tilemap.get_cell(x, y - 1) in walkable_tile_types:
				nav_connections.push_back({
					"id" : _get_index_for_xy(x, y, used_rect),
					"to_id" : _get_index_for_xy(x, y - 1, used_rect)
					})

			if (tilemap.get_cell(x + 1, y - 1) in walkable_tile_types and
				(tilemap.get_cell(x + 1, y) in walkable_tile_types or
				tilemap.get_cell(x, y - 1) in walkable_tile_types)
			):
				nav_connections.push_back({
					"id" : _get_index_for_xy(x, y, used_rect),
					"to_id" : _get_index_for_xy(x + 1, y - 1, used_rect)
					})

			if tilemap.get_cell(x - 1, y) in walkable_tile_types:
				nav_connections.push_back({
					"id" : _get_index_for_xy(x, y, used_rect),
					"to_id" : _get_index_for_xy(x - 1, y, used_rect)
					})

	for c in nav_connections:
		astar.connect_points(c["id"], c["to_id"])

	debug_connection_size = nav_connections.size()

func _get_index_for_xy(x : int, y : int, used_rect : Rect2) -> int :
	var x_modifier = used_rect.position.x * -1 if used_rect.position.x < 0 else used_rect.position.x
	var y_modifier = used_rect.position.y * -1 if used_rect.position.y < 0 else used_rect.position.y
	var id : int = int((y + y_modifier) * used_rect.size.x + x + x_modifier);
	assert(id >= 0)
	return id

func draw_debug():
	debug_node.update()
