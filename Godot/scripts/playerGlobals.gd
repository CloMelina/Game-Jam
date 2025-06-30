# Boilerplate code, written by Nick
# This node exists to keep track of player info. Any script anywhere in the game can access player
# location and other relevant info using this. 
extends Node

var player: CharacterBody3D
var player_pos: Vector3

# A few basic setters and getters for position and rotation
## Gets called by the player script when it enters the scene
func aquire_player(node: CharacterBody3D):
	player = node

## Returns the player's global position
func get_player_pos() -> Vector3:
	return player.global_position

## Teleports the player to the specified global coordinates
func set_player_pos(pos: Vector3):
	player.global_position = pos

## Returns the player's global rotation
func get_player_rot() -> Vector3:
	return player.global_rotation

## Instantly rotates the player to the spedified global rotation
func set_player_rot(rot: Vector3):
	player.global_rotation = rot

# Anything more advanced should just inteface with the player root node directly
## Returns the player root node.
func get_player() -> CharacterBody3D:
	return player
