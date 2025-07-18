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
@export var use_keybinds: Array[String] = ["use_1", "use_2"]

# Crosshair stays in the middle of the screen and does nothing when current_prompt is null
var current_prompt: InteractPrompt = null
var last_prompt: InteractPrompt
var screen_center: Vector2
var target: Vector2
var prompt_pos_last:= Vector2.ZERO
var prompt_pos_delta:= Vector2.ZERO
var is_player_taling := false

var keyboard_options : Array[InteractOption]
var mouse_options : Array[InteractOption]


func _physics_process(delta: float) -> void:
	update_current_prompt()
	# Get filtered prompt lists according to current qualifiers/disqualifiers/dialogic variables
	if current_prompt != null:
		keyboard_options = filter_options(current_prompt.options)
		mouse_options = filter_options(current_prompt.use_options)
	else :
		keyboard_options.clear()
		mouse_options.clear()
	update_text()

func _process(delta: float) -> void:
	# check if the player is talking, then become invisible and don't do anythng if they are
	is_player_taling = PlayerGlobals.is_talking()
	visible = !is_player_taling
	if is_player_taling:
		pass
	# update screen center
	screen_center = get_viewport_rect().size / 2
	
	# If a prompt is selected, then the crosshair hovers over that.
	if current_prompt:
		prompt_pos_last = target
		target = camera.unproject_position(current_prompt.global_position)
		prompt_pos_delta = target - prompt_pos_last if current_prompt == last_prompt else Vector2.ZERO
	else :
		# hang out in the middle of the screen if there is no prompt.
		target = screen_center
		prompt_pos_last = Vector2.ZERO
		prompt_pos_delta =  Vector2.ZERO
	
	# Smooth out crosshair motion
	position = position.lerp(target, clamp(delta * crosshair_speed, 0.0, 1.0)) + prompt_pos_delta

func _input(event: InputEvent) -> void:
	# don't do anything if player is talking
	if is_player_taling:
		return
	
	# check pressed key and see if they are interact buttons
	for i in interact_keybinds.size():
		if event.is_action_pressed(interact_keybinds[i]):
			if current_prompt != null and i < keyboard_options.size():
				current_prompt.activate(keyboard_options[i].identifier)
				return
			else:
				invalid_interact()
				return
	# repeat for use options
	for i in use_keybinds.size():
		if event.is_action_pressed(use_keybinds[i]):
			if current_prompt != null and i < mouse_options.size():
				current_prompt.activate(mouse_options[i].identifier)
				return
			else:
				invalid_interact()
				return

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
	last_prompt = current_prompt
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
		# update description text
		description.text = current_prompt.description
		# update button prompts
		for i in mouse_options.size():
			if mouse_options[i].hidden:
				continue
			label.text += ("\n" + get_key_for_action(use_keybinds[i]) + " - " + mouse_options[i].label)
		for i in keyboard_options.size():
			if keyboard_options[i].hidden:
				continue
			label.text += ("\n" + get_key_for_action(interact_keybinds[i]) + " - " + keyboard_options[i].label)
			

#TODO implement support for dialogic variables
## Removes options according to requisites/disqualifiers
func filter_options(options: Array[InteractOption]) -> Array[InteractOption]:
	var filtered_options: Array[InteractOption] = []
	for option: InteractOption in options:
		# check option enable flags
		if not option.enabled:
			continue
		# check if option requisites are fulfilled or disqualifiers are present
		if option.requisites.size() > 0:
			if not qual_check_exclusive(option.requisites):
				continue
		if option.disqualifiers.size() > 0:
			if option.disqualify_inclusive:
				if qual_check_inclusive(option.disqualifiers):
					continue
			else:
				if qual_check_exclusive(option.disqualifiers):
					continue
		# check dialogic variable
		if option.dialogic_var:
			#INFO if you get an error here, check that your dialogic variable is a boolean
			var dialogic_bool : bool = Dialogic.VAR.get(option.dialogic_var)
			if dialogic_bool and not option.dialogic_enables:
				continue
			if not dialogic_bool and option.dialogic_enables:
				continue
		# option passes all checks and gets included
		filtered_options.append(option)
	return filtered_options

# gets called whenever an interact button is pressed with no corresponding interact object
func invalid_interact() -> void:
	#TODO just play a sound or something idk
	pass

func qual_check_inclusive(requisites: Array[StringName]) -> bool:
	for requisite:StringName in requisites:
		if InteractRegistry.has_requisite(requisite):
			return true
	return false

func qual_check_exclusive(requisites: Array[StringName]) -> bool:
	var satisfied := 0
	for requisite:StringName in requisites:
		if InteractRegistry.has_requisite(requisite):
			satisfied += 1
	print(satisfied)
	return satisfied >= requisites.size()
