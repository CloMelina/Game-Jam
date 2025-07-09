extends CharacterBody3D
class_name NPC

@export var sprite : AnimatedSprite3D
@export var nav : NavigationAgent3D

## When true, the NPC will always turn to face the player each frame.
@export var face_player := true

## Global coordinates for the NPC to face instead of the player. Only used when face_player is false.
@export var alt_face_target : Vector3

## Higher number = less smoothing on Y rotation. Make this really big for instant rotation. 
@export var rotate_speed := 10.0

## Plays speaking animation when true
@export var talking := false

## Enables/disables NPC movement. 
@export var movement_enabled := true

## Determines the movement speed of the NPC when moving to the next nav point.
@export var movement_speed := 3.0

var anim_override := false
var target_velocity := Vector3.ZERO
var rotate_target := Vector3.ZERO
var impulse := Vector3.ZERO

func _ready() -> void:
	sprite.play("idle")

func _process(delta: float) -> void:
	if face_player:
		rotate_target = PlayerGlobals.get_player_pos()
	else:
		rotate_target = alt_face_target
	
	var dir = (global_position - rotate_target).normalized()
	var y_angle = atan2(dir.x, dir.z)
	#sprite.global_rotation.y = lerp(sprite.global_rotation.y, y_angle, rotate_speed * delta)
	sprite.global_rotation.y = _lerp_angle_delta(sprite.global_rotation.y, y_angle, delta, rotate_speed)

func _physics_process(delta: float) -> void:	
	# get navigation vector from navigation agent and move in that direction
	var nav_dir := global_position.direction_to(nav.get_next_path_position())
	target_velocity = nav_dir * movement_speed
	
	# apply gravity (why isn't this done automatically?)
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	
	# apply target_velocity to real velocity in a way that does not cancel gravity
	# basically add the y value instead of replacing it
	velocity = Vector3(
		target_velocity.x,
		velocity.y,
		target_velocity.z
	)
	
	# apply impulse forces and set the impulse vector back to zero
	velocity += impulse
	impulse = Vector3.ZERO
	
	move_and_slide()
	
	# Zero IQ animation system
	if velocity.length() > 0.1 and not anim_override:
		if is_on_floor() and sprite.animation != "walk":
			sprite.play("walk")
		elif not is_on_floor() and sprite.animation != "ragdoll":
			sprite.play("ragdoll")
	else:
		if talking and sprite.animation != "talk":
			sprite.play("talk")
		elif sprite.animation != "idle":
			sprite.play("idle")

#TODO DOES GODOT ACTUALLY NOT HAVE ANGLE AWARE LERP BUILT IN? AHHHHH
## Angle-aware lerp function that doesn't freak out when going from PI to -PI (and takes delta)
func _lerp_angle_delta(from: float, to: float, delta: float, weight: float) -> float:
	var t : float = clamp(delta * weight, 0.0, 1.0)
	var diff := wrapf(to - from, -PI, PI)
	return from + diff * t

func nav_to(to : Vector3):
	nav.target_position = to

func apply_impulse(force : Vector3):
	impulse += force
