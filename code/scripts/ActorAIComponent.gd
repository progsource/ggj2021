extends "res://scripts/ActorComponent.gd"

# States:
# - walk randomly around
# - follow player/pet (target)
#   - follow target with distance of 32 px
# - go home (get out of chain, jump, fade out)

# ------------------------------------------------------------------------------

class State:
	var parent = null

	func init():
		pass

	func process(_delta):
		pass

# ------------------------------------------------------------------------------

class RandomWalk:
	extends State

	var target_position := Vector2.ZERO
	var timer : Timer = null
	var astar = null
	
	func init():
		astar = GLOBAL.astar_tilemap_connector.astar
		timer = Timer.new()
		timer.autostart = true
		timer.wait_time = GLOBAL.rng.randi_range(2, 7)
		timer.one_shot = false
		timer.paused = false
		# warning-ignore:return_value_discarded
		timer.connect("timeout", self, "_on_timer_timeout")
		parent.actor.add_child(timer)

	func process(_delta):
		parent.actor.velocity = Vector2.ZERO

		if target_position == Vector2.ZERO:
			_create_new_target_position()
			timer.start()

		var closest_point_to_actor = astar.get_closest_point(parent.actor.global_position)
		var closest_point_to_target = astar.get_closest_point(Vector2(target_position.x, target_position.y))
		var path = astar.get_point_path(closest_point_to_actor, closest_point_to_target)

		parent._move_along_path(path)
		
	func _create_new_target_position():
		var x_modifier = GLOBAL.rng.randi_range(-10, 10) * 16
		var y_modifier = GLOBAL.rng.randi_range(-10, 10) * 16
		var closest_point_to_actor = astar.get_closest_point(parent.actor.global_position)
		var closest_point_to_target = astar.get_closest_point(Vector2(parent.actor.position.x + x_modifier, parent.actor.position.y + y_modifier))
		var path = astar.get_point_path(closest_point_to_actor, closest_point_to_target)
		if path.size() == 0:
			target_position = Vector2.ZERO
		else:
			target_position = path[path.size() - 1]
	
	func _on_timer_timeout():
		_create_new_target_position()

# ------------------------------------------------------------------------------

var states : Array = []
var current_state = null
var speed : float = 0.5

func _move_by_velocity(v : Vector2) -> void :
	actor.direction = v
	v *= actor.speed
	actor.velocity = v

func _move_along_path(path):
	if path.size() == 0:
		return

	var start_position = actor.position

	for i in range(path.size()):
		if i == 0:
			continue

		var velocity : Vector2
		if path[i].x < start_position.x:
			velocity.x = -1
		elif path[i].x > start_position.x:
			velocity.x = 1
		else:
			velocity.x = 0

		if path[i].y < start_position.y:
			velocity.y = -1
		elif path[i].y > start_position.y:
			velocity.y = 1
		else:
			velocity.y = 0

		if abs(velocity.x) == 1 and abs(velocity.y) == 1:
			velocity = velocity.normalized()

		if velocity.x == 0 and velocity.y == 0:
			continue

		_move_by_velocity(velocity * speed)
		break

func init() -> void :
	states.append(RandomWalk.new())

	for s in states:
		s.parent = self
		s.init()

	current_state = states[0]

func process(delta) -> void :
	current_state.process(delta)
