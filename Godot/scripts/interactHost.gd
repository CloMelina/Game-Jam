# Boilerplate code, written by Nick

# Actual UI element that displays the prompt and takes keyboard input
# Serves as a crosshair when not displaying an interact prompt

extends Node2D
class_name InteractHost

@onready var camera: Camera3D = get_tree().get_current_scene().get_node("Player/Camera3D")
@onready var label = $OptionText
@onready var description = $DescriptionText

## Crosshair glides to the on-screen position of prompts when they are focused. Bigger number = smoother motion
@export var crosshair_speed := 15.0

# probably a way to automate this but it really doesn't matter
## Keybinds used to execute interact options
@export var interact_keybinds: Array[String] = ["int_1", "int_2", "int_3", "int_4"]

# Crosshair stays in the middle of the screen and does nothing when current_prompt is null
var current_prompt: InteractPrompt = null
var screen_center: Vector2
var target: Vector2
var is_player_taling := false

func _physics_process(delta: float) -> void:
	update_current_prompt()
	update_text()

func _process(delta: float) -> void:
	# check if the player is talking, then become invisible and don't do anythng if they are
	is_player_taling = PlayerGlobals.is_talking()
	visible = !is_player_taling
	if is_player_taling:
		pass
	# update screen center
	#TODO not sure how fast (or slow) this is, maybe find a way to run this only when the resolution changes?
	screen_center = get_viewport_rect().size / 2
	
	# If a prompt is selected, then the crosshair hovers over that.
	if current_prompt:
		target = camera.unproject_position(current_prompt.global_position)
	else :
		# hang out in the middle of the screen if there is no prompt.
		target = screen_center
	
	# Smooth out crosshair motion
	position = position.lerp(target, clamp(delta * crosshair_speed, 0.0, 1.0))

func _input(event: InputEvent) -> void:
	# don't do anything if player is talking
	if is_player_taling:
		return
	
	# check currently pressed keys and see if they are interact buttons
	for i in interact_keybinds.size():
		if event.is_action_pressed(interact_keybinds[i]):
			if current_prompt != null and i < current_prompt.options.size():
				current_prompt.activate(i)
			else:
				invalid_interact()

func get_key_for_action(action_name: String) -> String:
	if not InputMap.has_action(action_name):
		return "?"
	var events = InputMap.action_get_events(action_name)
	for event in events:
		if event is InputEventKey:
			return OS.get_keycode_string(event.physical_keycode)
		elif event is InputEventMouseButton:
			match event.button_index:
				MOUSE_BUTTON_LEFT: return "LMB"
				MOUSE_BUTTON_RIGHT: return "RMB"
				MOUSE_BUTTON_MIDDLE: return "MMB"
				MOUSE_BUTTON_WHEEL_UP: return "Wheel Up"
				MOUSE_BUTTON_WHEEL_DOWN: return "Wheel Down"
				MOUSE_BUTTON_WHEEL_LEFT: return "Wheel Left"
				MOUSE_BUTTON_WHEEL_RIGHT: return "Wheel Right"
				_: return "Mouse " + str(event.button_index)
	return "?"

# Figures out which (if any) interaction prompt the player is looking at
func update_current_prompt() -> void:
	var cam_pos = camera.global_position
	var cam_dir = camera.global_transform.basis.z
	current_prompt = null
	
	# Update list of interact nodes
	var prompts = InteractRegistry.get_prompts()
	
	for prompt in prompts:
		var to_prompt = prompt.global_position - cam_pos
		var prompt_dist = to_prompt.length()
		
		# Skip prompts that don't pass the distance check or are otherwise disabled
		if prompt_dist > prompt.distance or prompt.is_visible_in_tree() == false or prompt.enabled == false:
			continue
		
		# Skip prompts that don't pass angle checks
		# TODO implement max angle check
		var prompt_dot = cam_dir.dot(to_prompt.normalized())
		if prompt_dot >= prompt.radius * -1:
			continue
		
		# Prompt has passed check and can be made target
		# If another prompt has already been made target, pick the one closer to matching the view vector.
		if current_prompt != null:
			var to_other = current_prompt.global_position - cam_pos
			var other_dot = cam_dir.dot(to_other.normalized())
			
			if other_dot < prompt_dot:
				continue
		current_prompt = prompt

func update_text() -> void:
	label.text = ""
	description.text = ""
	if current_prompt != null:
		# get all interact options and format them for display
		for i in current_prompt.options.size():
			var option = current_prompt.options[i]
			if option.hidden or not option.enabled:
				continue
			label.text += ("\n" + get_key_for_action(interact_keybinds[i]) + " - " + option.label)
		
		# update description text as well
		description.text = current_prompt.description

# gets called whenever an interact button is pressed with no corresponding interact object
func invalid_interact() -> void:
	#TODO just play a sound or something idk
	pass
