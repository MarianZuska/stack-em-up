extends Node2D

func play(file_path, pos=null, volume=-30):
	#var audio_player = AudioStreamPlayer2D.new()
	
	#if pos == null:
	var audio_player = AudioStreamPlayer.new()
	#else:
		#audio_player.position = pos
	
	self.add_child(audio_player)
	audio_player.stream = load(file_path)
	audio_player.volume_db = volume
	audio_player.play()

func _ready():
	play("res://Resources/Sound/Music/8-Bit_Dungeon.wav", null, -20)
