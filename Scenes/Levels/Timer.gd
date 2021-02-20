extends Node2D

var start_time = 0
var stop_time = 0

var play = false
onready var text = $Text

func start():
	play = true
	start_time = Utils.get_time()

func stop():
	if play == true:
		play = false
		stop_time = Utils.get_time()

func do_continue():
	if play == false:
		play = true
		start_time += Utils.get_time() - stop_time
	
func _process(delta):
	if play:
		text.text = str(int(Utils.get_time() - start_time))
