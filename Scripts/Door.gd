extends StaticBody2D

export(Array, NodePath) var buttons
export(int) var buttons_needed = 1
export(bool) var do_invert = false

onready var collision_shape = $CollisionShape2D
onready var sprite = $Sprite
onready var initial_modulate = modulate
onready var animation_player = $AnimationPlayer
var wasOpen = false

func _ready():
	for button in buttons:
		get_node(button).modulate = modulate

func _process(delta):
	var count = 0
	for button in buttons:
		if get_node(button).is_pressed == true:
			count += 1
	
	var open = false
	if count >= buttons_needed:
		open = true
		
	if do_invert:
		open = not open
	
	if open:
		collision_shape.disabled = true
	else:
		collision_shape.disabled = false
		
	if wasOpen and not open:
		animation_player.play("Close")
	elif not wasOpen and open:
		animation_player.play("Open")
	wasOpen = open
