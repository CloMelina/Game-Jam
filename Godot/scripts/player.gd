# Boilerplate code, written by Nick Heyart
extends CharacterBody3D

@export var look_scale_gpad := 2.8
@export var look_invert_gpad := false

@export var look_scale_mouse := 0.001
@export var look_invert_mouse := false

@export var movement_speed := 5.0

# these don't do anything yet
@export var can_move_during_dialogue := false
@export var look_at_speaker := true
@export var dialoge_cam_speed := 20

@onready var camera = $Camera3D

func _process(delta: float) -> void:
	# get camera inputs
	# dumbass single-state system that just sums gamepad and mouse inputs
	# will make the 12 steam controller users very happy but button prompts might be a bitch
	var look_dir = Input.get_vector("cam_left", "cam_right", "cam_up", "cam_down")
	
	# apply gamepad look sensitivity constant
	# TODO add acceleration curve; can't do precise movement with a linear setup
	look_dir *= -look_scale_gpad
	look_dir *= delta
	
	# apply gamepad look inversion if enabled
	if look_invert_gpad:
		look_dir *= -1
	
	# rotate player for horizontal looking
	rotate_y(look_dir.x)
	# rotate camera for vertical looking
	camera.rotate_x(look_dir.y)
	
	

func _physics_process(delta: float) -> void:
	# get movement inputs
	var move_dir = Input.get_vector("mv_left", "mv_right", "mv_forward", "mv_backward")
	
	# rotate movement vector to match player orientation
	move_dir = move_dir.rotated(-rotation.y)
	
	# apply movement speed
	move_dir *= movement_speed
	
	velocity = Vector3(move_dir.x, 0, move_dir.y)
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	# handle mouse camera input
	if event is InputEventMouseMotion:
		# apply mouse look sensitivity constant
		# TODO add mouse smoothing if appropriate
		var look_dir = event.relative * -look_scale_mouse
		
		# apply inverted mouselook if enabled
		if look_invert_mouse:
			look_dir *= -1
		
		# rotate player for horizontal looking
		rotate_y(look_dir.x)
		# rotate camera for vertical looking
		camera.rotate_x(look_dir.y)
	
	# handle mouse buttons
	if event is InputEventMouseButton:
		# check if mouse is in captured state, capture it if not
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
