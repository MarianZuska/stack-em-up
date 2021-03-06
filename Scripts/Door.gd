extends StaticBody2D

export(Array, NodePath) var buttons
export(int) var buttons_needed = 1
export(bool) var do_invert = false

onready var collision_shape = $CollisionShape2D
onready var sprite = $Sprite
onready var initial_modulate = modulate
onready var animation_player = $AnimationPlayer
onready var wasOpen = !do_invert

func _ready():
	for button in buttons:
		get_node(button).modulate = modulate

func _process(delta):
	var count = 0
	for button in buttons:
		if get_node(button).is_pressed == true:
			count += 1
	
	var open = count >= buttons_needed
		
	if do_invert:
		open = not open
	
	collision_shape.disabled = open
		
	if wasOpen and not open:
		animation_player.play("Close")
	elif not wasOpen and open:
		animation_player.play("Open")
	wasOpen = open
