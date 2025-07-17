#Author: Jimmie Cox
#Descritiption: This script primarily just serves as functions for the buttons to navigate to the
#different scenes. Those scenes being the scene.tscn (start game), credits.tscn (credits scene), and
#the quit function to close the game.

extends Control

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scene.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://credits.tscn")
