extends Node2D

func play(file_path, volume=-30):
	
	var audio_player = AudioStreamPlayer.new()
	
	self.add_child(audio_player)
	audio_player.stream = load(file_path)
	audio_player.volume_db = volume
	audio_player.play()

func _ready():
	play("res://Resources/Sound/Music/On My Way.wav", -20)
