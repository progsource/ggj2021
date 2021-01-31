extends KinematicBody2D

# order matters
# 1. input / ai
# 2. physics
# 3. animation
var components := []

var velocity : Vector2 = Vector2.ZERO
var speed : float = 95
var direction : Vector2 = Vector2.ZERO

func add_component(component) -> void :
	component.actor = self
	components.push_back(component)
	component.init()

# is called by ActorAnimationComponent
func play_animation(animation_name : String) -> void :
	$AnimationPlayer.play(animation_name)

func _input(event) -> void :
	for c in components:
		c.input(event)

func _process(delta) -> void :
	for c in components:
		c.process(delta)

func _physics_process(delta) -> void :
	for c in components:
		c.physics_process(delta)
