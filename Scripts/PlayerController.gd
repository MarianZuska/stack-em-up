extends Node2D

export(Array, NodePath) var player_root_nodes = []
var currently_active_index = 0

const PLAYER_COLLISION_SIZE_Y = -7.341
const PLAYER_COLLISION_OFFSET_Y = 2.637


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	activate_player()

func activate_player():
	var players = get_players()
	for index in range(len(players)):
		players[index].is_controlled = index == currently_active_index
		
func get_player_tree(reference_player):
	if reference_player == null:
		return []
	return [reference_player] + get_player_tree(reference_player.player_on_top)
	
func dist(p1, p2):
	return abs(p1.get_global_position().distance_to(p2.get_global_position()))
	
func stack_on_player(curr_player):
	for other_player in get_players():
		if curr_player != other_player and find_which_player_is_stacked_below(other_player) == null:
			if dist(curr_player, other_player) < 20:
				var other_player_tree = get_player_tree(other_player)
				var curr_player_tree = get_player_tree(curr_player)
				if not(curr_player in other_player_tree) and not(other_player in curr_player_tree):
					other_player.can_move = false
					get_collision_shape(other_player).disabled = true
					curr_player_tree[-1].player_on_top = other_player
					resize_collision_shape(other_player)
					break
	resize_collision_shape(curr_player)

func unstack_for_player(curr_player):
	var player = curr_player.player_on_top
	if player != null:
		# If unstack all players
		# unstack_for_player(curr_player.player_on_top)
		player.can_move = true
		get_collision_shape(player).disabled = false
		curr_player.player_on_top = null
		resize_collision_shape(player)
		resize_collision_shape(curr_player)
		
func get_collision_shape(for_player):
	return for_player.get_child(1)
		
func resize_collision_shape(for_player):
	var cs = get_collision_shape(for_player)
	var players_above = len(get_player_tree(for_player)) - 1
	cs.position.y = PLAYER_COLLISION_OFFSET_Y + PLAYER_COLLISION_SIZE_Y * players_above
	cs.scale.y = 1 + players_above
	#print(cs.shape.x, cs.shape.y)
		
func get_current_player():
	return get_players()[currently_active_index] 
			
func get_players(include_active=true):
	var player_list = []
	for index in range(len(player_root_nodes)):
		if not include_active && currently_active_index == index:
			continue
		player_list.append(get_node(player_root_nodes[index]).get_child(0))
	return player_list

func find_which_player_is_stacked_below(player_stacked_above):
	for player in get_players():
		if player != player_stacked_above:
			if player.player_on_top == player_stacked_above:
				return player
	return null

func throw_player_on_top():
	var current_player = get_current_player()
	if current_player.player_on_top != null:
		var thrown_player = current_player.player_on_top
		unstack_for_player(current_player)
		thrown_player.can_move = true
		thrown_player.throw(current_player.motion)

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
	for action in ["down", "left", "right", "up"]:
		if Input.is_action_just_pressed(action):
			var p = find_which_player_is_stacked_below(get_current_player())
			if p != null:
				unstack_for_player(p)
				break
				
	if Input.is_action_just_pressed("throw"):
		throw_player_on_top()
