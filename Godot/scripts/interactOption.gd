# Boilerplate code, written by Nick
# Stores info about an option in an interaction prompt
# Order in array determines corresponding button

extends Resource
class_name InteractOption

## Text prompt that will be displayed to the user
@export var label: String = ""

## Each option must get a unique identifier.
## This gets passed to your script when the interact signal is triggered so it can see what option is triggered.
## You can probably just make this the same as the label. Refrence existing object scripts if you are confused.
@export var identifier: StringName

## When false, the option will not be displayed and cannot be triggered.
## Disabled interactOptions still count towards the limit of 4 options per prompt, yell at Nick if this becomes an issue.
@export var enabled: bool = true

## When true, the text prompt will not show, but pressing the button will still trigger it. Useful for secrets.
@export var hidden: bool = false

## Option will not show up unless all these requisites are fulfilled. Case insensitive.
@export var requisites: Array[StringName]

## Option will not show up if all/any of these requisites are fulfilled. Case insensitive.
@export var disqualifiers: Array[StringName]

## Enable this option for inclusive disqualification.
## False means that the option will show unless all disqualifiers are fulfilled,
## True means that the option will not show if any disqualifiers are fulfilled.
@export var disqualify_inclusive: bool = false

## Enter the name of a boolean dialogic variable that should enable/disable the option.
@export var dialogic_var: StringName

## When this setting is false, the option gets disabled when the dialogic boolean is true.
## When this setting is true, the option is disabled unless the dialogic boolean is true.
## Use this when one option should get "replaced" by another.
@export var dialogic_enables: bool = false
