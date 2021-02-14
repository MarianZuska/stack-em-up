extends Area2D

export(String, FILE, "*.tscn") var scene

var hasTriggered = false

func _physics_process(delta):
	if not hasTriggered:
		var bodies = get_overlapping_bodies()
		for body in bodies:
			if body.name == "Player":
				hasTriggered = true
				SceneChanger.change_scene(scene, 0)
