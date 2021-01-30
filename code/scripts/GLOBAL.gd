extends Node

enum PetType {
	Cat0,
	Cat1,
	Cat2,
	Cat3,
	Cat4,
	Dog0,
	Dog1,
	Dog2,
	Dog3,
	Dog4,
	COUNT
}

const PetImageMap = {
	PetType.Cat0 : "cat0.png",
	PetType.Cat1 : "cat1.png",
	PetType.Cat2 : "cat2.png",
	PetType.Cat3 : "cat3.png",
	PetType.Cat4 : "cat4.png",
	PetType.Dog0 : "dog0.png",
	PetType.Dog1 : "dog1.png",
	PetType.Dog2 : "dog2.png",
	PetType.Dog3 : "dog3.png",
	PetType.Dog4 : "dog4.png",
}

var load_mutex = Mutex.new()
var rng : RandomNumberGenerator
var actor_factory = null


var is_char_female : bool = true
var on_wanted_id : int = -1


func _ready():
	rng = RandomNumberGenerator.new()
	rng.seed = OS.get_unix_time()
	rng.randomize()
	
	actor_factory = load_my_resource("res://scripts/ActorFactory.gd").new()

func load_my_resource(var path : String) -> Resource:
	load_mutex.lock()
	var result = load(path)
	load_mutex.unlock()
	return result
