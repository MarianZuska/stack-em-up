extends Area2D

var isPressed = false

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	isPressed = false
	for body in bodies:
		if body.name == "Player":
			isPressed = true
		
