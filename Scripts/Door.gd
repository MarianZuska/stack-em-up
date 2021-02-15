extends StaticBody2D

export(NodePath) var button

onready var collisionShape = $CollisionShape2D
onready var sprite = $Sprite

func _process(delta):
	if get_node(button).isPressed == true:
		collisionShape.disabled = true
		sprite.modulate = Color.transparent
	else:
		collisionShape.disabled = false
		sprite.modulate = Color.white
