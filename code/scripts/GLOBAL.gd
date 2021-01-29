extends Node

var rng : RandomNumberGenerator

func _ready():
	rng = RandomNumberGenerator.new()
	rng.seed = OS.get_unix_time()
	rng.randomize()
