# Boilerplate code, written by Nick after being awake for 30+ hours

extends Control

var paused = false
var original_mouse_mode = Input.MOUSE_MODE_CAPTURED

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
