extends Node

enum PetType {
	Cat0,
	Cat1,
	Cat2,
	Cat3,
	Cat4,
	Dog1,
	Dog2,
	Dog3,
	Dog4,
}

var rng : RandomNumberGenerator

func _ready():
	rng = RandomNumberGenerator.new()
	rng.seed = OS.get_unix_time()
	rng.randomize()
