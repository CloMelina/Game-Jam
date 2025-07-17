#Author: Jimmie Cox
#Description: This is a pretty straightforward script that basically defines the changes in the
#credits scene without having to use an animation node unless if later we want to use more fancy transistions,
#then we can just use an animation node (No Problem).

extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	await get_tree().create_timer(5.0).timeout
	
	$Role.text = "Graphic Design"
	$Individual.text = "Katie Kendrick | Pierceton Shell"
	
	
	await get_tree().create_timer(5.0).timeout
	
	$Role.text = "Sound Design"
	$Individual.text = "Chloe Allen"
	
	await get_tree().create_timer(5.0).timeout
	
	#Maybe add a special note section
	$Role.text = "Special Note"
	$Individual.text = "[Insert Generic Note Here]"
