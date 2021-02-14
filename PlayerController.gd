extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

export(Array, NodePath) var players = []
var currently_active_index = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_activate_player()

func _activate_player():
	for index in range(len(players)):
		var player = get_node(players[index])
		player.set("isControlled", index == currently_active_index)

func _merge_players():
	var curr_player = get_node(players[currently_active_index])
	for player in _get_players(false):
		var dist = curr_player.get_position().distance_to(player.get_position())
		#if true: # Check distance
		#	player.set("canMove", false)
			
func _get_players(include_active=true):
	var player_list = []
	for index in range(len(players)):
		if not include_active && currently_active_index == index:
			continue
		player_list.append(get_node(players[index]))
	return player_list
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("swap_character"):
		currently_active_index = (currently_active_index + 1) % len(players)
		_activate_player()
	if Input.is_action_just_pressed("merge_characters"):
		_merge_players()
