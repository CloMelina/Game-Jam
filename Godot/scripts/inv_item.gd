extends RigidBody3D

class_name InvItem

@export var item_name: String
@export var item_icon: CompressedTexture2D

## Offset to be applied from the standard hold location. Change this if the item looks weird when held.
@export var hold_position_offset: Vector3

## Rotation to use when held. Adjust this so that the item is in the correct orientation when held.
@export var hold_rotation: Vector3
