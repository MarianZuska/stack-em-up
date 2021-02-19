extends CanvasLayer

signal scene_changed()

onready var animation_player = get_node("AnimationPlayer")
onready var black = get_node("Control/BlackRect")

func change_scene(path, delay = 0.5, play_win = false, play_death = false):
	if play_win:
		SoundManager.play("res://Resources/Sound/SFX/Pickup.wav", -10)
	elif play_death:
		SoundManager.play("res://Resources/Sound/SFX/Hurt.wav", -10)
	
	yield(get_tree().create_timer(delay), "timeout")
	animation_player.play("Fade")
	yield(animation_player, "animation_finished")
	assert(get_tree().change_scene(path) == OK)
	Utils.game_over = false
	animation_player.play_backwards("Fade")
	yield(animation_player, "animation_finished")
	emit_signal("scene_changed")

func _process(delta):
	if Input.is_action_pressed("reset"):
		change_scene(get_tree().current_scene.filename, 0)
	if Input.is_action_pressed("ui_cancel"):
		change_scene("res://Scenes/Levels/MainMenu.tscn", 0.2)
