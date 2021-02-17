extends Area2D

var has_triggered = false

export(String, FILE) var next_level = null

func _physics_process(delta):
	if not has_triggered:
		var bodies = get_overlapping_bodies()
		for body in bodies:
			if body.name == "Player":
				has_triggered = true
				if next_level == null:
					next_level = get_tree().current_scene.filename
				SceneChanger.change_scene(next_level)
