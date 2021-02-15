extends Area2D

var hasTriggered = false

func _physics_process(delta):
	if not hasTriggered:
		var bodies = get_overlapping_bodies()
		for body in bodies:
			if body.name == "Player":
				hasTriggered = true
				SceneChanger.change_scene(get_tree().current_scene.filename, 0)
