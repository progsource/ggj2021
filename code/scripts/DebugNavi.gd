extends Node2D

export var color : Color = Color(0, 0, 200)

func _draw():
	if GLOBAL.astar_tilemap_connector.astar.get_points().size() == 0:
		return

	for p in GLOBAL.astar_tilemap_connector.astar.get_points():
		for c in GLOBAL.astar_tilemap_connector.astar.get_point_connections(p):
			var pp = GLOBAL.astar_tilemap_connector.astar.get_point_position(p)
			var cp = GLOBAL.astar_tilemap_connector.astar.get_point_position(c)
			draw_line(Vector2(pp.x, pp.y),
			Vector2(cp.x, cp.y),
			color)
