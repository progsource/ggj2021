extends CanvasLayer

func _ready():
	GLOBAL.game_data.time = 0
	_display_mode()
	
func _process(delta):
	if GLOBAL.game_data.pets <= 0:
		get_tree().change_scene("res://scenes/End.tscn")
	match GLOBAL.game_mode:
		GLOBAL.GameType.Time:
			_time_attack(delta)
		_:
			_time_attack(delta)

func _time_attack(delta):
	GLOBAL.game_data["time"] += delta
	var time = GLOBAL.game_data["max_time"] - GLOBAL.game_data["time"]
	if time <= 0:
		get_tree().change_scene("res://scenes/End.tscn")
	var seconds = fmod(time, 60)
	var minutes = fmod(time, 3600) / 60
	var str_elapsed = "%02d : %02d" % [minutes, seconds]
	$TimeBox/Container/Value.text = str_elapsed

func _display_mode():
	match GLOBAL.game_mode:
		GLOBAL.GameType.Time:
			$Mode.text = "Time Attack"
		GLOBAL.GameType.Math:
			$Mode.text = "Math Quiz"
		GLOBAL.GameType.Delivery:
			$Mode.text = "Delivery"
	
	$AnimationPlayer.play("show_mode")
