extends InteractPrompt

@onready var text = $MeshInstance3D
@onready var boom = $AnimatedSprite3D
@onready var sound = $AudioStreamPlayer3D

func _on_triggered(option: StringName) -> void:
	match option:
		"rotate":
			spin()
		"splode":
			splode()
		"pound":
			text.scale.y *= 0.9

func spin() -> void:
	text.rotate_y(PI/8)

func splode() -> void:
	boom.frame = 0
	boom.play("fucking_explode")
	sound.play()
