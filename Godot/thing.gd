extends InteractPrompt

@onready var text = $MeshInstance3D
@onready var boom = $AnimatedSprite3D
@onready var sound = $AudioStreamPlayer3D

func _on_option_0() -> void:
	text.rotate_y(PI/8)

func _on_option_1() -> void:
	boom.frame = 0
	boom.play("fucking_explode")
	sound.play()
