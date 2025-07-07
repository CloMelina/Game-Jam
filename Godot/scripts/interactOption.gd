# Boilerplate code, written by Nick
# Stores info about an option in an interaction prompt
# Order in array determines corresponding button

extends Resource
class_name InteractOption

## Text prompt that will be displayed to the user
@export var label: String = ""

## When false, the option will not be displayed and cannot be triggered.
## Disabled interactOptions still count towards the limit of 4 options per prompt, yell at Nick if this becomes an issue.
@export var enabled: bool = true

## When true, the text prompt will not show, but pressing the button will still trigger it. Useful for secrets.
@export var hidden: bool = false

#TODO maybe add input override if that's important?
