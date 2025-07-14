extends ColorRect

var inv_slots := []

func _ready() -> void:
	for child in $InvSlots.get_children():
		inv_slots.append(child)

func pickup(item: InvItem) -> void:
	# find the first empty slot
	var curr_slot: ColorRect
	for slot in inv_slots:
		if slot.is_empty():
			curr_slot = slot
			break
	
	# curr_slot will be null if all slots are full
	if curr_slot == null:
		invalid_pickup()
		return
	
	curr_slot.set_item(item)
	if item.get_parent():
		item.get_parent().remove_child(item)

func invalid_pickup() -> void:
	#TODO play a sound, flash text, something to indicate that inventory is full
	pass
