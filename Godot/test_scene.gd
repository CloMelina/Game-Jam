extends Node3D

@onready var npc = $NPCMan
@onready var rainbow = $GAY

func _ready() -> void:
	npc.nav_to(Vector3(25, 1, 0))

func _on_interact_prompt_option_0() -> void:
	npc.apply_impulse(Vector3.UP * 5)

func _on_interact_prompt_option_2() -> void:
	PlayerGlobals.cam_look_at(rainbow.global_position)
