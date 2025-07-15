extends ColorRect

@onready var left_hand = $"../Camera3D/LeftHand"
@onready var right_hand = $"../Camera3D/RightHand"

var inv_slots := []
var selected_slot := 0
var num_keys := ["inv_0", "inv_1", "inv_2", "inv_3", "inv_4", "inv_5", "inv_6", "inv_7", "inv_8", "inv_9"]
var has_scrolled := false

func _ready() -> void:
	for child in $InvSlots.get_children():
		inv_slots.append(child)
	PlayerGlobals.aquire_inventory(self)

func _input(event: InputEvent) -> void:
	# Handle scroll input
	# Horizontal scroll is mapped to these actions as well, since some browsers and OSes convert shift+scroll to horizontal scrolling which triggers when sprinting.
	if event.is_action("inv_left"):
		print(has_scrolled)
		#HACK only accept one scroll input per physics tick to avoid duplicate inputs, could break with higher physics tick rates
		if has_scrolled:
			return
		has_scrolled = true
		change_slot(wrapi(selected_slot - 1, 0, inv_slots.size()))
	elif event.is_action("inv_right"):
		if has_scrolled:
			return
		has_scrolled = true
		change_slot(wrapi(selected_slot + 1, 0, inv_slots.size()))
	else:
		# Handle number keys
		for i in num_keys.size():
			if event.is_action_pressed(num_keys[i]):
				change_slot(i)
				break
	
	inv_slots[selected_slot].selected = true

func _physics_process(delta: float) -> void:
	has_scrolled = false	

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

## Updates the currently selected slot and hand mesh.
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
	
	print(right_hand.get_children())
