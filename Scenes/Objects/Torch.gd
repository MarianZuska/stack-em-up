extends Node2D


export(float) var time = 0.1

onready var next_flicker = Utils.get_time() + time
onready var start_scale = $Light.texture_scale
onready var target_scale = start_scale
onready var rng = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()


func _process(delta: float) -> void:
	if Utils.get_time() >= next_flicker:
		next_flicker += time
		target_scale = start_scale + rng.randf_range(-0.1, 0.1)
	$Light.texture_scale += (target_scale - start_scale) * (delta / time)
		
