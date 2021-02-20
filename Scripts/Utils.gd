extends Node

var time_s = 0.0
var game_over = false

var timer_on = false
var timer = null
onready var timer_scene = preload("res://Scenes/Levels/Timer.tscn")

func get_time():
	return time_s

# also returns true on level selector scene
func can_pause():
	var scene_name = get_tree().current_scene.filename
	return (scene_name.begins_with("res://Scenes/Levels/Level") or 
		scene_name == "res://Scenes/Levels/EndingScreen.gd")

func _process(delta):
	time_s += delta

func toggle_timer():
	timer_on = not timer_on
	if timer_on:
		timer = timer_scene.instance()
		get_tree().get_root().get_child(0).add_child(timer)
	elif timer != null:
		timer.queue_free()
		
