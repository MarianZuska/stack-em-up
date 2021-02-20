extends MarginContainer

onready var selectors = [
	$CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/HBoxContainer/Selector,
	$CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer4/HBoxContainer/Selector,
	$CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer2/HBoxContainer/Selector,
	$CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer3/HBoxContainer/Selector,
	]

var current_selection = 0
onready var pause_menu = get_node(".")

func _ready():
	setCurrentSelection(0)

func setCurrentSelection(index):
	current_selection = index
	for i in range(len(selectors)):
		if i == index:
			selectors[i].text = ">"
		else:
			selectors[i].text = ""

func handleSelection():
	if current_selection == 0:
		SceneChanger.pause_menu_on = false
		pause_menu.queue_free()
	elif current_selection == 1:
		SceneChanger.change_scene(get_tree().current_scene.filename, 0)
		SceneChanger.pause_menu_on = false
		pause_menu.queue_free()
	elif current_selection == 2:
		SceneChanger.change_scene("res://Scenes/Levels/MainMenu.tscn", 0)
		SceneChanger.pause_menu_on = false
		pause_menu.queue_free()
	elif current_selection == 3:
		get_tree().quit()
		
func validate_index(index):
	return clamp(index, 0, selectors.size()-1)

func _process(delta):
	if Input.is_action_just_pressed("ui_down"):
		setCurrentSelection(validate_index(current_selection + 1))
	elif Input.is_action_just_pressed("ui_up"):
		setCurrentSelection(validate_index(current_selection - 1))
	elif Input.is_action_just_pressed("ui_accept"):
		handleSelection()
	
