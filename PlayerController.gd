extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

export(Array, NodePath) var player_root_nodes = []
var currently_active_index = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_activate_player()

func _activate_player():
	var players = _get_players()
	for index in range(len(players)):
		players[index].set("isControlled", index == currently_active_index)

func _merge_player(curr_player):
	for player in _get_players(false):
		var dist = curr_player.get_global_position().distance_to(player.get_global_position())
		if abs(dist) < 20:
			player.set("canMove", false)
			player.get_child(1).disabled = true
			curr_player.playerOnTop = player

func _unmerge_player(curr_player):
	var player = curr_player.playerOnTop
	if player != null:
		_unmerge_player(curr_player.playerOnTop)
		player.set("canMove", true)
		player.get_child(1).disabled = false
		curr_player.playerOnTop = null
		
func _get_current_player():
	return _get_players()[currently_active_index] 
			
func _get_players(include_active=true):
	var player_list = []
	for index in range(len(player_root_nodes)):
		if not include_active && currently_active_index == index:
			continue
		player_list.append(get_node(player_root_nodes[index]).get_child(0))
	return player_list
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("swap_character"):
		currently_active_index += 1
		currently_active_index %= len(player_root_nodes)
		_activate_player()
	if Input.is_action_just_pressed("merge_characters"):
		_merge_player(_get_current_player())
	if Input.is_action_just_pressed("unmerge_characters"):
		_unmerge_player(_get_current_player())
