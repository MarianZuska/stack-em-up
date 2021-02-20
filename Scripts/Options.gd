extends MarginContainer

onready var selectors = [
	$CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/HBoxContainer/Selector,
	$CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer4/HBoxContainer/Selector,
	$CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer2/HBoxContainer/Selector,
	$CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer3/HBoxContainer/Selector,
	$CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer5/HBoxContainer/Selector
	]

var currentSelection = 0

func _ready():
	setCurrentSelection(0)

func setCurrentSelection(index):
	currentSelection = index
	for i in range(len(selectors)):
		if i == index:
			selectors[i].text = ">"
		else:
			selectors[i].text = ""

func handleSelection(_currentSelection):
	if currentSelection == 0:
		SoundManager.toogle_music()
	elif currentSelection == 1:
		SoundManager.change_volume(10)
	elif currentSelection == 2:
		SoundManager.change_volume(-10)
	elif currentSelection == 3:
		Utils.toggle_timer()
	elif currentSelection == 4:
		SceneChanger.change_scene("res://Scenes/Levels/MainMenu.tscn", 0)
		
func validate_index(index):
	return clamp(index, 0, selectors.size()-1)

func _process(delta):
	if Input.is_action_just_pressed("ui_down"):
		setCurrentSelection(validate_index(currentSelection + 1))
	elif Input.is_action_just_pressed("ui_up"):
		setCurrentSelection(validate_index(currentSelection - 1))
	elif Input.is_action_just_pressed("ui_accept"):
		handleSelection(currentSelection)
	
