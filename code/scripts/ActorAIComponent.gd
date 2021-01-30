extends "res://scripts/ActorComponent.gd"

# States:
# - walk randomly around
# - follow player/pet (target)
#   - follow target with distance of 32 px
# - go home (get out of chain, jump, fade out)

# ------------------------------------------------------------------------------

class State:
	var parent = null
	var next = null
	var name : String = "" # for debug

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
		name = "RandomWalk"
		astar = GLOBAL.astar_tilemap_connector.astar
		timer = Timer.new()
		timer.autostart = true
		timer.wait_time = GLOBAL.rng.randi_range(2, 7)
		timer.one_shot = false
		timer.paused = false
		# warning-ignore:return_value_discarded
		timer.connect("timeout", self, "_on_timer_timeout")
		parent.actor.add_child(timer)
		GLOBAL.event_bus.connect("follow_chain", self, "_on_follow_chain_updated")

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

	func _on_follow_chain_updated(actor_object, target_object) -> void:
#		print("in %s" % name)
		if parent.current_state != self:
			return

		if actor_object != parent.actor or target_object == null:
			return

		timer.disconnect("timeout", self, "_on_timer_timeout")
		timer.queue_free()
		GLOBAL.event_bus.disconnect("follow_chain", self, "_on_follow_chain_updated")
		parent.current_state = next
		parent.speed = 1.8
#		print(parent.current_state.name, " is now active")

# ------------------------------------------------------------------------------

class FollowChain:
	extends State

	const min_distance = 34

	var astar = null
	var target = null

	func init():
		name = "FollowChain"
		astar = GLOBAL.astar_tilemap_connector.astar
		GLOBAL.event_bus.connect("follow_chain", self, "_on_follow_chain_updated")

	func process(_delta):
		if not target:
			return
			
		var distance = parent.actor.global_position.distance_to(target.global_position)
		if distance <= min_distance:
			parent.actor.direction = Vector2.ZERO
			parent.actor.velocity = Vector2.ZERO
			return
			
		var closest_point_to_actor = astar.get_closest_point(parent.actor.global_position)
		var closest_point_to_target = astar.get_closest_point(target.global_position)
		var path = astar.get_point_path(closest_point_to_actor, closest_point_to_target)

		parent._move_along_path(path)

	func _on_follow_chain_updated(actor_object, target_object) -> void:
		if actor_object != parent.actor:
			return
			
		target = target_object
		if parent.current_state != self:
			return
		if target == null:
			GLOBAL.event_bus.disconnect("follow_chain", self, "_on_follow_chain_updated")
			parent.current_state = next

# ------------------------------------------------------------------------------

class GoHome:
	extends State
	
	var target = null
	var astar = null
	
	func init():
		name = "GoHome"
		astar = GLOBAL.astar_tilemap_connector.astar
		GLOBAL.event_bus.connect("follow_release", self, "_on_follow_release")
		
	func process(_delta):
		if not target:
			return
			
		var distance = parent.actor.global_position.distance_to(target.delivery_spot.global_position)
		if distance <= 8:
			parent.actor.direction = Vector2.ZERO
			parent.actor.velocity = Vector2.ZERO
			parent.actor.play_animation("idle")
			target = null
			parent.actor.hide()
			parent.actor.set_process(false)
			return

		var closest_point_to_actor = astar.get_closest_point(parent.actor.global_position)
		var closest_point_to_target = astar.get_closest_point(target.delivery_spot.global_position)
		var path = astar.get_point_path(closest_point_to_actor, closest_point_to_target)

		parent._move_along_path(path)

	func _on_follow_release(actor_object, target_object) -> void:
		if actor_object != parent.actor or target_object == null:
			return
			
		target = target_object
		GLOBAL.event_bus.disconnect("follow_release", self, "_on_follow_release")
		parent.current_state = self

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

	if GLOBAL.DEBUG:
		debug_path(path)

	var start_position = actor.position

	for i in range(path.size()):
		if i == 0:
			continue

		var velocity : Vector2 = Vector2.ZERO
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
	states.append(FollowChain.new())
	states.append(GoHome.new())

	states[0].next = states[1]
	states[1].next = states[2] # TODO: go home

	for s in states:
		s.parent = self
		s.init()

	current_state = states[0]

func process(delta) -> void :
	if current_state:
		current_state.process(delta)
		
func debug_path(path):
	if GLOBAL.debug_path && current_state && current_state.name == "FollowChain":
		var debug = actor.get_node("debug")
		if not debug:
			return
		debug.clear_points()
		for point in path:
			debug.add_point(actor.transform.xform_inv(point))
