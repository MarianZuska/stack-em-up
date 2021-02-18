extends StaticBody2D

export(float) var time = 1.0
export(bool) var do_invert = false


onready var collision_shape = $CollisionShape2D
onready var sprite = $Sprite
onready var initial_modulate = modulate
onready var animation_player = $AnimationPlayer

onready var active = true
onready var wasActive = false
onready var nextSwitch = time

func _ready():
	if do_invert:
		wasActive = true
		active = false
	
func _process(delta):
	
	if Utils.get_time() >= nextSwitch:
		nextSwitch += time
		active = not active
	
	if active:
		collision_shape.disabled = true
	else:
		collision_shape.disabled = false
		
	if wasActive and not active:
		animation_player.play("Close")
	elif not wasActive and active:
		animation_player.play("Open")
	wasActive = active
