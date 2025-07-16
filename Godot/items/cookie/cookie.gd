extends InvItem

@onready var mesh = $Cookie
@onready var munch = $AudioStreamPlayer
@onready var partic_1 = $GPUParticles3D
@onready var partic_2 = $GPUParticles3D2

var in_hand = false

func _on_interact_prompt_option_0() -> void:
	pickup()

func _on_interact_prompt_option_1() -> void:
	eat()

func _on_used_1() -> void:
	in_hand = true
	PlayerGlobals.inventory.input_blocked = true
	eat()

## MUNCH
func eat():
	munch.play()
	partic_1.global_rotation = Vector3.ZERO
	partic_1.emitting = true
	partic_2.global_rotation = Vector3.ZERO
	partic_2.emitting = true
	mesh.visible = false
	item_prompt.enabled = false

func _on_audio_stream_player_finished() -> void:
	if in_hand:
		PlayerGlobals.inventory.input_blocked = false
		PlayerGlobals.clear_slot()

	else:
		get_parent().remove_child(self)
