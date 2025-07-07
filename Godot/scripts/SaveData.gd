#Author: James "i really should go to sleep cause it's 12:42 PM now" Cox
#Description: This is the script that simply extends a Resource class and names it
#saveDataResource. In this example, we just have one variable we're trying to save 
#which is health. It is exported as an int set to the integer 100.


extends Resource
class_name saveDataResource

#Example of the text rotation node
@export var mesh_rotation: Vector3 = Vector3.ZERO
