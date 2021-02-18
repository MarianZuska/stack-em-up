extends Area2D

var has_triggered = false

export(String, FILE) var next_level = null
export(PackedScene) var play_particles = null
export(bool) var is_win = false
export(bool) var is_death = false

func _physics_process(delta):
	if not has_triggered:
		var bodies = get_overlapping_bodies()
		for body in bodies:
			if body.name == "Player":
				has_triggered = true
				if next_level == null: 
					next_level = get_tree().current_scene.filename
				if play_particles != null:
					var particles = play_particles.instance()
					# particles.set_name("Particles")
					add_child(particles)
					particles.get_child(0).restart()
				SceneChanger.change_scene(next_level, 0.5, is_win, is_death)
