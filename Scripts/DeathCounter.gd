extends Label

func _ready():
	if Utils.deaths == 0:
		text = "Impressive! You did not die at all!"
	else:
		var plural = "time" if Utils.deaths == 1 else "times"
		text = "You died " + str(Utils.deaths) + plural
