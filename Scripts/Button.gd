extends Area2D

var is_pressed = false

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	is_pressed = false
	for body in bodies:
		if body.name == "Player":
			is_pressed = true
			
	if is_pressed == false:
		$Sprite.frame = 0
	else: 
		$Sprite.frame = 1
