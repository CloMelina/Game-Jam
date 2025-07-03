# Boilerplate code, written by Nick after being awake for 30+ hours

extends Control

@onready var test_mesh = $"../shit ass table/InteractPrompt/MeshInstance3D"

var paused = false
var original_mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _ready() -> void:
	$PanelContainer2/VBoxContainer/WindowOption.select(0)
	$PanelContainer2/VBoxContainer/AntiOption.select(1)
	
	$PanelContainer2/VBoxContainer/HSlider.value = 1.00
	
func _init() -> void:
	# just to be sure we don't get ghost pause menus
	visible = false

# TODO put animations on pause/unpause
func pause():
	# actually pause the game logic
	get_tree().paused = true
	paused = true
	
	# keep track of what state the mouse is in. Should be captured most of the time,
	# but maybe there's a menu that has it in a different state. idk. this should handle it.
	original_mouse_mode = Input.mouse_mode
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	#print("paused")
	#TODO animate pause mennu appearing if feeling saucy
	visible = true

func resume():
	# resume the game logic frfr
	get_tree().paused = false
	paused = false
	
	# restore the mouse state saved on pause
	Input.mouse_mode = original_mouse_mode
	
	#print("resumed")
	#TODO reverse show animation ig??
	visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if paused:
			resume()
		else:
			pause()

func _on_resume_pressed() -> void:
	# literally just unpause
	resume()

func _on_restart_pressed() -> void:
	# reloads current scene, no save system beyond making a new scene
	resume()
	get_tree().reload_current_scene()

func _on_options_pressed() -> void:
	pass #TODO implement options for graphics and controls

func _on_quit_pressed() -> void:
	# i think this unloads everything and the game just closes
	# this might go back to the main menu once we have one??
	#TODO make main menu and see what the quit button does
	get_tree().quit()
	

func _on_save_pressed() -> void:
	#print("Rotation before saving", test_mesh.rotation)
	SaveLoad.saveFileData.mesh_rotation = test_mesh.rotation
	SaveLoad._save()

func _on_load_pressed() -> void:
	SaveLoad._load()
	test_mesh.rotation = SaveLoad.saveFileData.mesh_rotation
	#print(test_mesh.rotation)
	
	
func _on_window_option_item_selected(index: int) -> void:
	if index == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _on_anti_option_item_selected(index: int) -> void:
	
	#Ensure each option when selected turns off the opposite
	#So if FXAA chosn (index 1) turn off MSAA and vice versa.
	
	if index == 0: #Disabled
		get_viewport().msaa_3d = 0
		get_viewport().screen_space_aa = 0
	elif index == 1: #FXAA
		get_viewport().msaa_3d = 0
		get_viewport().screen_space_aa = 1
	elif index == 2: #MSAA 2X
		get_viewport().msaa_3d = 1
		get_viewport().screen_space_aa = 0
	elif index == 3: #MSAA 4X
		get_viewport().msaa_3d = 2
		get_viewport().screen_space_aa = 0
	elif index == 4: #MSAA 8X
		get_viewport().msaa_3d = 3
		get_viewport().screen_space_aa = 0
		
		
func _on_h_slider_value_changed(value: float) -> void:
	$PanelContainer2/VBoxContainer/ScreenResolutionOutput.text = str(value)
	#Change viewport dependent on slider value
	get_viewport().scaling_3d_scale = value
	#$Antialiasing/RenderScaleContainer/Value.text = "%d%%" % (value * 100)


func _on_vsync_option_item_selected(index: int) -> void:
	
	if index == 0: # Disabled (default)
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	elif index == 1: # Enabled
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	elif index == 2: # Adaptive
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_MAILBOX)
