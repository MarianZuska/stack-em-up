extends Node2D

export(Array, NodePath) var player_root_nodes = []
var currently_active_index = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	activate_player()

func activate_player():
	var players = get_players()
	for index in range(len(players)):
		players[index].set("is_controlled", index == currently_active_index)
		
func get_player_tree(reference_player):
	if reference_player == null:
		return []
	return [reference_player] + get_player_tree(reference_player.player_on_top)
	
func dist(p1, p2):
	return abs(p1.get_global_position().distance_to(p2.get_global_position()))
	
func stack_on_player(curr_player):
	for other_player in get_players(false):
		if dist(curr_player, other_player) < 20:
			var other_player_tree = get_player_tree(other_player)
			var curr_player_tree = get_player_tree(curr_player)
			if not(curr_player in other_player_tree) and not(other_player in curr_player_tree):
				other_player.set("can_move", false)
				other_player.get_child(1).disabled = true
				curr_player_tree[-1].player_on_top = other_player

func unstack_for_player(curr_player):
	var player = curr_player.player_on_top
	if player != null:
		# If unstack all players
		# unstack_for_player(curr_player.player_on_top)
		player.set("can_move", true)
		player.get_child(1).disabled = false
		curr_player.player_on_top = null
		
func get_current_player():
	return get_players()[currently_active_index] 
			
func get_players(include_active=true):
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
		activate_player()
	if Input.is_action_just_pressed("merge_characters"):
		stack_on_player(get_current_player())
	if Input.is_action_just_pressed("unmerge_characters"):
		unstack_for_player(get_current_player())
