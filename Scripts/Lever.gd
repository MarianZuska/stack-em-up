extends Area2D

var is_pressed = false
var did_overlap = false
export(PackedScene) var particles_on_press = null

func _physics_process(delta):
			
	if overlaps() and  not did_overlap:
		SoundManager.play("res://Resources/Sound/SFX/Land3.wav", -15)

		var particles = particles_on_press.instance()
		particles.modulate = modulate
		particles.position = position
		get_tree().get_current_scene().add_child(particles)
		particles.restart()
		
		if is_pressed:
			$Sprite.frame = 1
		else:
			$Sprite.frame = 0
		
		is_pressed = not is_pressed
		
	did_overlap = overlaps()

func overlaps():
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player": 
			return true
	return false
