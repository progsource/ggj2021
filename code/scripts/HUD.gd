extends CanvasLayer

func _ready():
	GLOBAL.game_data.time = 0
	
func _process(delta):
	match GLOBAL.game_mode:
		GLOBAL.GameType.Time:
			_time_attack(delta)
		_:
			_time_attack(delta)

func _time_attack(delta):
	GLOBAL.game_data["time"] += delta
	var seconds = fmod(GLOBAL.game_data.time, 60)
	var minutes = fmod(GLOBAL.game_data.time, 3600) / 60
	var str_elapsed = "%02d : %02d" % [minutes, seconds]
	$TimeBox/Container/Value.text = str_elapsed
