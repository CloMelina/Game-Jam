# Boilerplate code, written by Nick Heyart
extends CharacterBody3D

@export var look_scale_gpad := 2.8
@export var look_invert_gpad := false

@export var look_scale_mouse := 0.001
@export var look_invert_mouse := false

@export var movement_speed := 5.0

@export var move_during_dialogue := false
@export var look_at_speaker := true

@export var cam_speed := 50
@export var dialoge_cam_speed := 20

@onready var camera = $Camera3D

var cam_target : Vector3
var is_talking = false
var has_cam_control = true
var has_move_control = true

func _process(delta: float) -> void:
	# determine if player has cam and movement control
	has_cam_control = not is_talking and look_at_speaker
	has_move_control = not is_talking and not move_during_dialogue
	
	# handle gamepad cam input if player has cam control
	if has_cam_control:
		gpd_cam_update(delta)
	
	# camera smoothing gets updated every tick no matter what
	# should happen after everything else that might influence the camera target
	smooth_cam_update(delta)

func _physics_process(delta: float) -> void:
	# get movement inputs
	var move_dir = Input.get_vector("mv_left", "mv_right", "mv_forward", "mv_backward")
	
	# rotate movement vector to match player orientation
	move_dir = move_dir.rotated(-rotation.y)
	
	# apply movement speed
	move_dir *= movement_speed
	
	# apply movement input if player has movement control
	if has_move_control:
		velocity = Vector3(move_dir.x, 0, move_dir.y)
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	# handle mouse camera input
	if event is InputEventMouseMotion:
		mouse_cam_update(event)
	
	# handle mouse buttons
	if event is InputEventMouseButton:
		# check if mouse is in captured state, capture it if not
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

## Handle mouse camera input
func mouse_cam_update(event: InputEvent) -> void:
	# apply mouse look sensitivity constant
	var look_dir = event.relative * -look_scale_mouse
	
	# apply inverted mouselook if enabled
	if look_invert_mouse:
		look_dir *= -1
	
	# update cam target
	cam_target.x += look_dir.x
	cam_target.y += look_dir.y

## Handle gamepad camera input
func gpd_cam_update(delta: float) -> void:
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
	
	# update cam target
	cam_target.x += look_dir.x
	cam_target.y += look_dir.y

## Smooths out all camera movement; should be executed each frame
func smooth_cam_update(delta: float) -> void:
	# wrap cam_target between PI and -PI to prevent glitches when turning more than 180°
	cam_target = euler_wrap(cam_target)
	
	# get the camera rotation info in a sane format
	var cam_current = Vector3(rotation.y, camera.rotation.x, camera.rotation.z)
	
	# get the current camera movement speed based on if there is dialogue happening right now
	var curr_cam_speed = cam_speed if is_talking else dialoge_cam_speed
	
	# calculate smoothed camera rotation
	cam_current.x = lerp_angle_delta(cam_current.x, cam_target.x, delta, curr_cam_speed)
	cam_current.y = lerp_angle_delta(cam_current.y, cam_target.y, delta, curr_cam_speed)
	cam_current.z = lerp_angle_delta(cam_current.z, cam_target.z, delta, curr_cam_speed)
	
	# apply calculated rotation
	rotation.y = cam_current.x
	camera.rotation.x = cam_current.y
	camera.rotation.z = cam_current.z

#TODO double-check that there is no built-in function for vector wrapping. this sucks.
## Wraps a vector's values between PI and -PI, useful for euler rotations
func euler_wrap(v: Vector3) -> Vector3:
	return Vector3(
		wrapf(v.x, -PI, PI),
		wrapf(v.y, -PI, PI),
		wrapf(v.z, -PI, PI)
	)

#TODO DOES GODOT ACTUALLY NOT HAVE ANGLE AWARE LERP BUILT IN? AHHHHH
## Angle-aware lerp function that doesn't freak out when going from PI to -PI (and takes delta)
func lerp_angle_delta(a: float, b: float, delta: float, speed: float) -> float:
	var t : float = clamp(delta * speed, 0.0, 1.0)
	var diff := wrapf(b - a, -PI, PI)
	return a + diff * t
