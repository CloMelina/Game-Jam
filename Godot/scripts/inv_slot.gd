extends ColorRect

@onready var tex_rect = $TextureRect

@export var inv_item : InvItem
@export var selected := false

const glide_speed := 10.0
const select_offset := 0.3

func change_image(image: Texture2D):
	tex_rect.image = image

# have the item icon glide up smoothly when selected
func _process(delta: float) -> void:
	# calculate vertical offset in pixels based on the icon's height
	var target_px = tex_rect.size.y * select_offset if selected else 0.0
	
	# smooth out position
	var current_px = tex_rect.position.y * -1
	current_px = lerp(current_px, target_px, glide_speed * delta)
	tex_rect.position.y = current_px * -1

## Returns true if the slot is empty.
func is_empty() -> bool:
	return inv_item == null

func set_item(item: InvItem):
	inv_item = item
	tex_rect.image = item.item_icon
