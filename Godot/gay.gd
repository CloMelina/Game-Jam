# made by nick, stupid gay easteregg
extends Sprite3D

@onready var smooch_sound = $smoocher
@onready var gex = $gex
@onready var laugh = $laugh_please

var smooch_screen = preload("res://smooch_screen.tscn")
var smooch_node : Node

func _on_interact_prompt_option_0() -> void:
	smooch_sound.play()
	smooch_node = smooch_screen.instantiate()
	add_child(smooch_node)

func _on_interact_prompt_option_1() -> void:
	gex.play()

func _process(delta: float) -> void:
	var gex_time = gex.get_playback_position()
	if gex_time > 3.2 and gex_time < 9.5:
		if fmod(gex_time, 1.0) > 0.5:
			laugh.visible = true
		else:
			laugh.visible = false
