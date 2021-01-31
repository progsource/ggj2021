extends Control

func _ready():
	if OS.has_feature('JavaScript'):
		$VBoxContainer/ExitButton.hide()
	else:
		# warning-ignore:return_value_discarded
		$VBoxContainer/ExitButton.connect("button_up", self, "on_exit")
	
	# warning-ignore:return_value_discarded
	$VBoxContainer/HBoxContainer/PlayFem.connect("button_up", self, "on_play_fem")
	# warning-ignore:return_value_discarded
	$VBoxContainer/HBoxContainer/PlayGuy.connect("button_up", self, "on_play_guy")

	GLOBAL.follow_chain.clear()


func on_exit() -> void :
	get_tree().quit()


func on_play_fem() -> void :
	GLOBAL.is_char_female = true
	_load_scene()


func on_play_guy() -> void :
	GLOBAL.is_char_female = false
	_load_scene()


func _load_scene() -> void :
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/TreeVillageTile.tscn")
