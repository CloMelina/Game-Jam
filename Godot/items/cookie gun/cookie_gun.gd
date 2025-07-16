extends InvItem

@export var cookie_speed := 5.0
@export var max_cookie_spin := 0.01

@onready var partcs_1 = $GPUParticles3D
@onready var partcs_2 = $GPUParticles3D2
@onready var cookie_scene = preload("res://items/cookie/Cookie.tscn")

func _on_interact_prompt_option_0() -> void:
	pickup()

# fire gun
func _on_used_1() -> void:
	# fire particles
	partcs_1.restart()
	partcs_2.restart()
	partcs_1.emitting = true
	partcs_2.emitting = true
	
	#TODO make noise, spawn high velocity cookie, recoil animation
	var cookie : InvItem = cookie_scene.instantiate()
	get_tree().current_scene.add_child(cookie)
	cookie.global_position = partcs_1.global_position
	cookie.global_rotation = partcs_1.global_rotation
	cookie.apply_central_impulse(global_basis.z * cookie_speed)
	cookie.apply_torque_impulse(Vector3(randf_range(max_cookie_spin * -1, max_cookie_spin), randf_range(max_cookie_spin * -1, max_cookie_spin), randf_range(max_cookie_spin * -1, max_cookie_spin)))
