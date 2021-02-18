extends Node2D

func play(file_path, pos=null, volume=-30):
	var player = AudioStreamPlayer2D.new()
	
	if pos == null:
		player = AudioStreamPlayer.new()
	else:
		player.position = pos
	
	self.add_child(player)
	player.stream = load(file_path)
	player.volume_db = volume
	player.play()

func _ready():
	play("res://Resources/Sound/On My Way.wav", null, -20)
