extends RigidBody3D

@onready var prompt: InteractPrompt = $Sprite3D/InteractPrompt

func _on_interact_prompt_option_0() -> void:
	apply_central_impulse(Vector3.UP * 50)

func _on_interact_prompt_option_1() -> void:
	apply_central_impulse(Vector3.RIGHT * 50)
