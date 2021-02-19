extends StaticBody2D

export(float) var time = 1.0
export(bool) var do_invert = false


onready var collision_shape = $CollisionShape2D
onready var sprite = $Sprite
onready var initial_modulate = modulate
onready var animation_player = $AnimationPlayer

onready var active = true
onready var was_active = false
onready var next_switch = Utils.get_time() + time

func _ready():
	if do_invert:
		was_active = true
		active = false
	
func _process(delta):
	if Utils.get_time() >= next_switch:
		next_switch += time
		active = not active
	
	collision_shape.disabled = active
	
	if was_active and not active:
		animation_player.play("Close")
	elif not was_active and active:
		animation_player.play("Open")
	was_active = active
