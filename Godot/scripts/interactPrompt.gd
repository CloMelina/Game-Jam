# Boiler plate code, written by Nick while subsisting on a caffine pill and 2 granola bars

# This node gets placed on anything the player can interact with. 

extends Node3D
class_name InteractPrompt
#TODO add icon
#TODO figure something out to show keyboard or controler prompts, either automatic or a setting

## Text that will be displayed to the player when they hover over the prompt.
@export var description: String

## List of interaction options made available to the player
@export var options: Array[InteractOption]

## List of "use" options that get mapped to left/right mouse buttons.
## Use this for actions that can only be done with a specific item equipped.
@export var use_options: Array[InteractOption]

## How close the player has to be looking at the prompt for it to show. Lower numbers for larger objects.
@export var radius := 0.95

## Maximum distance the player can trigger the prompt from
@export var distance := 2.0

# TODO Implement this
## Limits the angle that the prompt can be accessed from. -1 is 360°, 0 is 180°, goes up to 1.
## Useful for things like buttons mounted on surfaces where unlimited angle would allow interaction from behind the button.
#@export var max_angle := -1.0

## Disables the prompt completely.
@export var enabled := true

signal triggered(option: StringName)

func activate(option: StringName) -> void:
	triggered.emit(option)

# Keep registry up to date
func _ready():
	InteractRegistry.register_prompt(self)

func _exit_tree():
	InteractRegistry.unregister_prompt(self)
