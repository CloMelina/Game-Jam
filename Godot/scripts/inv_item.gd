extends RigidBody3D

class_name InvItem

@export var item_name: String
@export var item_icon: CompressedTexture2D
@export var item_prompt: InteractPrompt

## Description of this item's primary use action. Gets shown to the player when equipped. Leave blank if there is no primary use action.
@export var use_primary_text: String

## Description of this item's secondary use action. Gets shown to the player when equipped. Leave blank if there is no secondary use action.
@export var use_secondary_text: String

## Requisites satisfied by this item. Case insensitive.
@export var requisites: Array[StringName] = []

## Item's velocity when thrown.
@export var throw_velocity := 5.0

## Offset to be applied from the standard hold location. Change this if the item looks weird when held.
@export var hold_position_offset: Vector3

## Rotation in radians to use when held. Adjust this so that the item is in the correct orientation when held.
@export var hold_rotation: Vector3

## Player has equipped the item and pressed the primary use button.
signal used_1

## Player has equipped the item and pressed the secondary use button.
signal used_2

## Add item to player's inventory
func pickup() -> void:
	PlayerGlobals.pickup(self)

## Trigger primary use
func use_1() -> void:
	used_1.emit()

## Trigger secondary use
func use_2() -> void:
	used_2.emit()
