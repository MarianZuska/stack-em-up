extends Label

onready var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	if rng.randf() < 0.5:
		text = "Made by Brutenis Gliwa and Marian Zuska"
	else:
		text = "Made by Marian Zuska and Brutenis Gliwa"
