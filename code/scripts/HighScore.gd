extends HBoxContainer

onready var score = $Score

func _ready():
	var time = GLOBAL.game_data.time
	var seconds = fmod(time, 60)
	var minutes = fmod(time, 3600) / 60
	var str_elapsed = "%02d : %02d" % [minutes, seconds]
	score.text = str_elapsed
