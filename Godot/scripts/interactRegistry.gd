# Boilerplate code, written by Nick
# This node exists to keep track of all active interaction prompts. Prompt nodes should automatically
# register themselves with this node when made active, and can disable themselves by unregistering.
# This is basically an array with extra steps. I have exported the array so that it can be accessed
# directly if that is ever needed, but you should probably only be calling the built-in functions.
extends Node

## prompts currently available to be interacted with. Probably don't edit this array directly.
@export var prompts: Array[InteractPrompt] = []

## requisites temporarily fulfilled by items the player is currently holding.
@export var requisites: Array[StringName] = []

## requisites fulfilled by the player itself, regardless of what item they are holding
@export var player_requisites: Array[StringName] = []

var curr_item: InvItem

func register_prompt(prompt: InteractPrompt):
	prompts.append(prompt)

func unregister_prompt(prompt: InteractPrompt):
	prompts.erase(prompt)

func get_prompts() -> Array[InteractPrompt]:
	return prompts

func update_item(item: InvItem):
	curr_item = item
	requisites.clear()
	if item:
		requisites.append_array(item.requisites)

func clear_requisite(req: StringName) -> void:
	requisites.erase(req.to_lower())

func has_requisite(req: StringName) -> bool:
	var req_lower = req.to_lower()
	return requisites.has(req_lower) or player_requisites.has(req_lower)
