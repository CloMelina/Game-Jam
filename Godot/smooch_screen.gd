extends Sprite2D

@onready var mat := material as ShaderMaterial
var timer := 0.01

func _ready() -> void:
	randomize()
	queue_free_later()
	mat = mat.duplicate() as ShaderMaterial
	material = mat
	mat.set_shader_parameter("hue_shift", randf())

func _init() -> void:
	var resolution = DisplayServer.window_get_size()
	position = Vector2(randf_range(0, resolution.x), randf_range(0, resolution.y))
	rotation = randf_range(0, 2*PI)

func _process(delta: float) -> void:
	timer += delta / 1.8
	mat.set_shader_parameter("fade", min(1, (1 / timer) -0.1))

func queue_free_later():
		await get_tree().create_timer(30.0).timeout
		queue_free()
