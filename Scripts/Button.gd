extends Area2D

var is_pressed = false

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	is_pressed = false
	for body in bodies:
		if body.name == "Player":
			is_pressed = true
