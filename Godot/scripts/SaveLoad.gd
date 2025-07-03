#Author: James "I Should Go To Sleep Because It's 12:33PM" Cox
#Description: This SaveLoad Script is intended to hold functions that serve the purpose of
#saving, loading, and encrypting the saved data file which is stored in "user://SaveFile.tres". It also shows
#the implementation of saving and loading data in the final two functions _on_save_pressed and _on_load_pressed
#if you were looking to save or load in a game scene.

extends Node

#This is the constant that defines where the save file will be stored.
const saveLocation = "user://SaveFile.tres"

#This creates a new isntance of a custom resource class which can be found in SaveData.gd
var saveFileData: saveDataResource = saveDataResource.new() 

#This is the variable that will hold an encryption key to be used in the _save() and _load() functions.
#This is what will ensure the save file stays secure and not tampered with.
var encryptionKey: String = ""

#_ready():
#Description: The _ready() function begins by opening the user://key.txt location and checks to see 
#if there already is an encrypted key file that exists. If it does exists, we read that line and store the 
#encryption key into the encryptionKey variable and then closes the file. Otherwise, we generate a new key and 
#write that key to the key.txt file, store it, and then close the file.
	#Parameters: NONE
func _ready() -> void:
	
	if FileAccess.file_exists("user://key.txt"): #If it exists
		var file = FileAccess.open("user://key.txt", FileAccess.READ) #Read it
		encryptionKey = file.get_line() #Store it
		file.close() #Close it
	else:
		encryptionKey = _generateRandomKey()
		var file = FileAccess.open("user://key.txt", FileAccess.WRITE)
		file.store_line(encryptionKey)
		file.close()
	

#_generateRandomKey():
#Description: This function uses the lowercase and uppercase alphabet and 0-9 digits for our key which 
#is going to be a 32 character random string. We randomly choose 32 characters, and store that in encrypted key. We
#can really do any length we want, but since 32 is kind of a standard that's what I went with.
	#Parameters: NONE
func _generateRandomKey() -> String:
	var alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	var encryptedKey = ""
	for i in 32:
		encryptedKey = encryptedKey + alphabet[randi() % alphabet.length()]
	return encryptedKey

#_save():
#Description: This will take a savedFile variable which holds the saveLocation "user://SaveFile.tres" that will be
#written to in an encrypted mode with the encryption key. We save the data as a dictionary and store the data as a JSON
#string which is written to the saveLocation and then the file is closed.
	#Parameters: NONE
func _save():
	var savedFile = FileAccess.open_encrypted_with_pass(saveLocation, FileAccess.WRITE, encryptionKey)
	
	#This is the data we are saving put as a dictionary so that it's able to be passed through stringify().
	#If more data needs to be stored, write in the same way that health is written.
	var dataToSave = {
		#In this case, Stringify won't work so it needs to be converted to an array before saving
		"mesh_rotation": {
			"x": saveFileData.mesh_rotation.x,
			"y": saveFileData.mesh_rotation.y,
			"z": saveFileData.mesh_rotation.z
		}
	}
	
	#print("Data being saved: ", dataToSave)
	
	#We take the data and use the stringify function to put this into a JSON file
	var dictJSON = JSON.stringify(dataToSave)
	
	#This takes the data and stores it to the encrypted file
	savedFile.store_string(dictJSON) #Store it
	savedFile.close() #Close it
	
	
#_load():
#Description: Essentially just the opposite of _save(): where we instead of writing to "user://SaveFile.tres"
#we are reading from it. We parse the JSON string and store it in data. Close the file and then create a new saveDataResource
#and store that as our saveFileData and then for each variable, we simply reload it.  
	#Parameters: NONE
func _load():
	if FileAccess.file_exists(saveLocation):
		var savedFile = FileAccess.open_encrypted_with_pass(saveLocation, FileAccess.READ, encryptionKey)
		var data = JSON.parse_string(savedFile.get_as_text())
		savedFile.close()
		
		saveFileData = saveDataResource.new()
		
		#print(data)
		
		var textRotation = data.mesh_rotation
		saveFileData.mesh_rotation = Vector3(textRotation.x, textRotation.y, textRotation.z)
		
#_resetSaveFile():
#Description: This simply creates a new saveFileData which is a new saveDataResource so it resets your save which
#might come in handy or be useful when you want to basically set your information back to default. Could be useful when
#implementing a settings scene so if you want to put your settings back to default. 
	#Parameters: NONE
func _resetSaveFile():
	saveFileData = saveFileData.new()
	_save()
		
		
		
#Quick description: This code below is an example of a save and load button that would either
#save or load data in a scene. The purpose of SaveLoad.gd is to act as a global scene that can then be called
#in other scenes like a game scene. If you're unsure how to implement the loading and saving in a scene of the game
#go ask Jimmie to explain this further. In the example code above, the only data being stored is health so in the case
#of wanting to save or load a user's health variable, you would replace the [someVariable] with health.		

#func _on_save_pressed() -> void:
#	SaveLoad.saveFileData.[someVariable] = [someVariable] 
#	SaveLoad._save()
	
#func _on_load_pressed() -> void:
#	SaveLoad._load()
#	[someVariable] = SaveLoad.saveFileData.[someVariable]
#	$[someVariable].value = SaveLoad.saveFileData.[someVariable]
