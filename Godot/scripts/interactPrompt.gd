# Boiler plate code, written by Nick while subsisting on a caffine pill and 2 granola bars

# This node gets placed on anything the player can interact with. 

extends Node3D
class_name InteractPrompt
#TODO add icon
#TODO figure something out to show keyboard or controler prompts, either automatic or a setting

## List of interaction options made available to the player
@export var options: Array[InteractOption]

## How close the player has to be looking at the prompt for it to show. Lower numbers for larger objects.
@export var radius := 0.9

## Maximum distance the player can trigger the prompt from
@export var distance := 2.0

## Limits the angle that the prompt can be accessed from. -1 is 360°, 0 is 180°, goes up to 1.
@export var max_angle := -1.0

# signals that you can use to actually do things
# this feels wrong but the better methods are just a little bit really fucking complicated
signal option_0
signal option_1
signal option_2
signal option_3

func activate(index: int) -> void:
	match index:
		0: emit_signal("option_0")
		1: emit_signal("option_1")
		2: emit_signal("option_2")
		3: emit_signal("option_3")

# Keep registry up to date
func _ready():
	InteractRegistry.register_prompt(self)

func _exit_tree():
	InteractRegistry.unregister_prompt(self)
