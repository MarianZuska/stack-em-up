extends Area2D

export(String, FILE, "*.tscn") var scene

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			SceneChanger.change_scene(scene, 0)
