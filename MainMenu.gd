extends MarginContainer

onready var selectors = [$CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/HBoxContainer/Selector,
						$CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer2/HBoxContainer/Selector,
						$CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer3/HBoxContainer/Selector]

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
		SceneChanger.change_scene("res://MarianPlayground.tscn", 0)
	elif currentSelection == 1:
		print("Clicked options!")
		SceneChanger.change_scene("res://MainMenu.tscn", 0)
	elif currentSelection == 2:
		get_tree().quit()
		
		
	

func _process(delta):
	if Input.is_action_just_pressed("ui_down"):
		setCurrentSelection((currentSelection + 1) % len(selectors))
	elif Input.is_action_just_pressed("ui_up"):
		setCurrentSelection((currentSelection - 1) % len(selectors))
	elif Input.is_action_just_pressed("ui_accept"):
		handleSelection(currentSelection)
	
