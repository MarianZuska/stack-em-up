extends Node

var time_s = 0.0

func get_time():
	return time_s

func _process(delta):
	time_s += delta
