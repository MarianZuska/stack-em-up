extends MarginContainer

func _ready():
	if Utils.timer != null:
		Utils.timer.stop()
