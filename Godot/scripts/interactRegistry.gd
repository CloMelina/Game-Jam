# Boilerplate code, written by Nick
# This node exists to keep track of all active interaction prompts. Prompt nodes should automatically
# register themselves with this node when made active, and can disable themselves by unregistering.
# This is basically an array with extra steps. I have exported the array so that it can be accessed
# directly if that is ever needed, but you should probably only be calling the built-in functions.
extends Node

@export var prompts: Array[InteractPrompt] = []

func register_prompt(prompt: InteractPrompt):
	prompts.append(prompt)

func unregister_prompt(prompt: InteractPrompt):
	prompts.erase(prompt)

func get_prompts() -> Array[InteractPrompt]:
	return prompts
