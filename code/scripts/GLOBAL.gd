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

const GameType = {
	"Time" : "Time",
	"Math" : "Math",
	"Delivery": "Delivery",
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

var game_data = {
	"time": 0,
	"best_time": 0,
}

var game_mode = GameType.Time

var load_mutex = Mutex.new()
var rng : RandomNumberGenerator
var actor_factory = null
var pet_type_object_pool = null
var event_bus = null
var astar_tilemap_connector = null
var chain_controller = null


var is_char_female : bool = true
var on_wanted_id : int = -1
var follow_chain = null
var debug_path = true

func _ready():
	rng = RandomNumberGenerator.new()
	rng.seed = OS.get_unix_time()
	rng.randomize()

	actor_factory = load_my_resource("res://scripts/ActorFactory.gd").new()
	pet_type_object_pool = load_my_resource("res://scripts/PetTypeObjectPool.gd").new()
	pet_type_object_pool.init_pool()
	event_bus = load_my_resource("res://scripts/EventBus.gd").new()

	astar_tilemap_connector = load_my_resource("res://scripts/AStarTileMapConnector.gd").new()
	astar_tilemap_connector.init_astar()

	follow_chain = load_my_resource("res://scripts/Fifo.gd").new()
	
	_randomize_game_mode()
	chain_controller = load_my_resource("res://scripts/ChainController.gd").new()
	chain_controller.init()

func load_my_resource(var path : String) -> Resource:
	load_mutex.lock()
	var result = load(path)
	load_mutex.unlock()
	return result
	
func _randomize_game_mode() -> void :
	var key = GameType.keys()[rng.randi_range(0, GameType.keys().size() - 1)]
	game_mode = GameType[key]
