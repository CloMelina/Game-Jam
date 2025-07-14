extends InvItem

@onready var interact_prompt = $InteractPrompt

func _on_interact_prompt_option_0() -> void:
	interact_prompt.enabled = false
