extends InvItem

func _on_interact_prompt_triggered(option: StringName) -> void:
	match option:
		"pickup":
			pickup()
