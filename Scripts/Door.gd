extends StaticBody2D

export(Array, NodePath) var buttons
export(int) var buttonsNeeded
export(bool) var doInvert

onready var collisionShape = $CollisionShape2D
onready var sprite = $Sprite

func _process(delta):
	var count = 0
	for button in buttons:
		if get_node(button).isPressed == true:
			count += 1
	
	var open = false
	if count >= buttonsNeeded:
		open = true
		
	if doInvert:
		open = not open
	
	if open:
		collisionShape.disabled = true
		sprite.modulate = Color.transparent
	else:
		collisionShape.disabled = false
		sprite.modulate = Color.white
