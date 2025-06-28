# Boilerplate code, written by Nick
# Stores info about an option in an interaction prompt
# Order in array determines corresponding button

extends Resource
class_name InteractOption

## Text prompt that will be displayed to the user
@export var label: String = ""

## When enabled, the text prompt will not show. Useful for secrets.
@export var hidden: bool = false

#TODO maybe add input override if that's important?
