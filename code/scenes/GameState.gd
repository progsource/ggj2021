extends HBoxContainer

onready var state = $Label
var won : bool = false

func _ready():
	won = GLOBAL.game_data.pets <= 0
	state.text = "Lost"
	if won:
		state.text = "Won"
