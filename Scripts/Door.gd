extends StaticBody2D

export(Array, NodePath) var buttons
export(int) var buttons_needed = 1
export(bool) var do_invert = false
export(Color) var color = Color.white

onready var collision_shape = $CollisionShape2D
onready var sprite = $Sprite

func _ready():
	modulate = color
	for button in buttons:
		get_node(button).modulate = color

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
		sprite.modulate = Color.transparent
	else:
		collision_shape.disabled = false
		sprite.modulate = color
