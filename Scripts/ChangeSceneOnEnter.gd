extends Area2D

var has_triggered = false

export(String, FILE) var next_level = null
export(PackedScene) var play_particles = null
export(bool) var is_win = false
export(bool) var is_death = false

func _ready():
	if is_win and next_level in Utils.completed_levels:
		modulate = Color(.8, 1, .6)

func _physics_process(delta):
	if not has_triggered:
		var bodies = get_overlapping_bodies()
		for body in bodies:
			if body.name == "Player":
				has_triggered = true
				if next_level == null: 
					next_level = get_tree().current_scene.filename
				var play_death_sound = false
				if is_death and not Utils.game_over:
					body.is_controlled = false
					play_death_sound = true
					Utils.game_over = true
					Utils.deaths += 1

				if play_particles != null and (play_death_sound or is_win):
					var particles = play_particles.instance()
					particles.set_name("Particles")
					particles.position = position 
					get_tree().get_current_scene().add_child(particles)
					particles.get_child(0).restart()
					
				if is_win:
					Utils.completed_levels.append(get_tree().get_current_scene().filename)

				SceneChanger.change_scene(next_level, 0.5, is_win, play_death_sound)
				
