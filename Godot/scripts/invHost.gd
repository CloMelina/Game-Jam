extends ColorRect

@onready var right_hand = $"../Camera3D/RightHand"
@onready var left_hand = $"../Camera3D/LeftHand"
@onready var equip_text = $EquipText

@export var inv_slots := []
@export var selected_slot := 0

@export var input_blocked := false

var num_keys := ["inv_0", "inv_1", "inv_2", "inv_3", "inv_4", "inv_5", "inv_6", "inv_7", "inv_8", "inv_9"]

func _ready() -> void:
	for child in $InvSlots.get_children():
		inv_slots.append(child)
	PlayerGlobals.aquire_inventory(self)

func _input(event: InputEvent) -> void:
	if input_blocked:
		return
	# Handle scroll input
	# Horizontal scroll is mapped to these actions as well, since some browsers and OSes convert shift+scroll to horizontal scrolling which triggers when sprinting.
	if event.is_action_pressed("inv_left"):
		change_slot(wrapi(selected_slot - 1, 0, inv_slots.size()))
		return
	elif event.is_action_pressed("inv_right"):
		change_slot(wrapi(selected_slot + 1, 0, inv_slots.size()))
		return
	else:
		# Handle number keys
		for i in num_keys.size():
			if event.is_action_pressed(num_keys[i]):
				change_slot(i)
				return
	
	# handle item use buttons
	if event.is_action_pressed("use_1") and inv_slots[selected_slot].inv_item:
		inv_slots[selected_slot].inv_item.use_1()
	elif event.is_action_pressed("use_2") and inv_slots[selected_slot].inv_item:
		inv_slots[selected_slot].inv_item.use_2()
	return

func pickup(item: InvItem) -> void:
	# find the first empty slot
	var curr_slot: ColorRect
	var curr_slot_index: int
	for i in inv_slots.size():
		if inv_slots[i].is_empty():
			curr_slot = inv_slots[i]
			curr_slot_index = i
			break
	
	# curr_slot will be null if all slots are full
	if curr_slot == null:
		invalid_pickup()
		return
	
	# remove item from scene tree and freeze its physics
	if item.get_parent():
		item.get_parent().remove_child(item)
		curr_slot.set_item(item)
		item.freeze = true
	
	# update if the item is being put into the currently selected slot
	if curr_slot_index == selected_slot:
		change_slot(selected_slot)

func invalid_pickup() -> void:
	#TODO play a sound, flash text, something to indicate that inventory is full
	pass

## Updates the currently selected slot and hand mesh, as well as the equip text.
func change_slot(slot_num: int) -> void:
	# clear the right hand of any previous items
	for child in right_hand.get_children():
		right_hand.remove_child(child)
	
	# select specified slot
	inv_slots[selected_slot].selected = false
	selected_slot = slot_num
	inv_slots[selected_slot].selected = true
	
	# add selected item as a child of right hand so it is visible	
	var item : InvItem = inv_slots[selected_slot].inv_item
	if item:
		right_hand.add_child(item)
		item.position = item.hold_position_offset
		item.rotation = item.hold_rotation
	
	# update equip text
	equip_text.text = ""
	if item:
		equip_text.text += item.item_name
		if item.use_primary_text or item.use_secondary_text:
			equip_text.text += "\n"
			if item.use_primary_text:
				equip_text.text += get_key_for_action("use_1") + " - " + item.use_primary_text
			if item.use_primary_text and item.use_secondary_text:
				equip_text.text += "  |  "
			if item.use_secondary_text:
				equip_text.text += get_key_for_action("use_2") + " - " + item.use_secondary_text

func get_key_for_action(action_name: String) -> String:
	if not InputMap.has_action(action_name):
		return "?"
	var events = InputMap.action_get_events(action_name)
	for event in events:
		if event is InputEventKey:
			return OS.get_keycode_string(event.physical_keycode)
		elif event is InputEventMouseButton:
			match event.button_index:
				MOUSE_BUTTON_LEFT: return "LMB"
				MOUSE_BUTTON_RIGHT: return "RMB"
				MOUSE_BUTTON_MIDDLE: return "MMB"
				MOUSE_BUTTON_WHEEL_UP: return "Wheel Up"
				MOUSE_BUTTON_WHEEL_DOWN: return "Wheel Down"
				MOUSE_BUTTON_WHEEL_LEFT: return "Wheel Left"
				MOUSE_BUTTON_WHEEL_RIGHT: return "Wheel Right"
				_: return "Mouse " + str(event.button_index)
	return "?"

## Clears the specified inventory slot, defaults to selected slot. Returns the invItem in the slot.
func clear_slot(slot_num:= selected_slot) -> InvItem:
	# get the slot and return null if it is empty
	var slot = inv_slots[slot_num]
	
	if not slot.inv_item:
		return null
	
	# empty out the slot
	var item = slot.inv_item
	slot.inv_item = null
	slot.change_image(null)
	
	# clear right hand if the slot is selected
	if slot_num == selected_slot:
		for child in right_hand.get_children():
			right_hand.remove_child(child)
	
	return item
