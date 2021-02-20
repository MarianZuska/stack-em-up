extends Node2D


export(float) var time = 0.1

onready var next_flicker = Utils.get_time() + time
onready var start_scale = $Light.texture_scale
onready var target_scale = start_scale
onready var rng = RandomNumberGenerator.new()
onready var noise = OpenSimplexNoise.new()

func _ready() -> void:

	# Configure
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 0.08
	noise.persistence = 0.8


func _process(delta: float) -> void:
	if Utils.get_time() >= next_flicker:
		next_flicker += time
		target_scale = start_scale + (noise.get_noise_1d(Utils.get_time()) * 0.15)
	$Light.texture_scale += (target_scale - start_scale) * (delta / time)
		
