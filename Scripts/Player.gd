extends KinematicBody2D

const TARGET_FPS = 60
const ACCELERATION = 16
const MAX_SPEED = 100
const FRICTION = 24
const AIR_RESISTANCE = 2
const WALL_SLIDE_SPEED = 50
const DASH_SPEED = 175
const DASH_DURATION = 0.2

const JUMP_FORCE = 200
const WALL_JUMP_FORCE = 140
const MAX_FALL_SPEED = 400
const GRAVITY = 6
const FALL_MULTIPLIER = 2.5
const LOW_JUMP_MULTIPLIER = 5

const GROUND_HANG_TIME = 0
const WALL_HANG_TIME = 0.2
const JUMP_BUFFER_TIME = 0.25

const CAM_LOOK_AHEAD_SPEED = 6
const CAM_LOOK_AHEAD_AMOUNT = 50

const NO_MOVE_LEFT_TIME = 0.25
const NO_MOVE_RIGHT_TIME = 0.25

const PUSH_FACTOR = 10

const JUMP_SFX = "res://Resources/Sound/SFX/Jump3.wav"
const LAND_SFX = "res://Resources/Sound/SFX/Land.wav"

var hangCounter = 0
var jumpBufferCounter = 0

var noMoveLeftCounter = 0
var noMoveRightCounter = 0

var xinput = 0
var motion = Vector2.ZERO

var canDash = false
var dashDir = Vector2.ZERO
var dashing = false

var jumping_now = false
var player_on_top = null
var was_on_floor = true

var can_move = true
var is_controlled = true

onready var sprite = get_node("Sprite")
onready var animationPlayer = get_node("AnimPlayer")
onready var anchor = get_node("../Anchor")
onready var parent = get_owner()
onready var particleAnchor = get_node("ParticleAnchor")

onready var fx_land = preload("res://Scenes/Particles/LandParticle.tscn")
onready var fx_jump = preload("res://Scenes/Particles/JumpDustParticle.tscn")
onready var fx_foot = get_node("ParticleAnchor/FootDustParticle")

	
func _physics_process(delta):
	jumping_now = false
	
	if is_controlled:
		sprite.modulate = parent.player_color
		
	else:	
		var c = parent.player_color / 3 
		c[3] = 1
		sprite.modulate = c

	if can_move:
		if is_controlled:
			run(delta)
			jump(delta)
			dash()
		else:
			xinput = 0
		gravity(delta)
		friction(delta)

		move_anchor(delta)
		animate()
		particles()
	
		sound()
		
		close_down()
		
		motion = move_and_slide(motion, Vector2.UP, false, 4, PI/4, false)
		
		for index in get_slide_count():
			var collision = get_slide_collision(index)
			if collision.collider.is_in_group("movable"):
				# collision.collider.apply_central_impulse(-collision.normal * velocity.length() * 0.5)
				collision.collider.apply_central_impulse(-collision.normal * PUSH_FACTOR)
	if player_on_top != null:
		var pos = get_global_position() + Vector2(0, -16)
		player_on_top.set_global_position(pos)
		player_on_top.sprite.flip_h = sprite.flip_h
	

func sound():
	if Utils.get_time() >= 0.5:
		if not was_on_floor and is_on_floor():
			SoundManager.play(LAND_SFX, position, 0)
		if jumping_now:
			SoundManager.play(JUMP_SFX, position, -20)
		

func close_down():
	was_on_floor = is_on_floor()

func particles():
	
	var c = parent.player_color / 3.5
	c[3] = 1
		
	var land = false
	var jump = false
	var run = false
	if not was_on_floor and is_on_floor():
		land = true
		
	if jumping_now:
		jump = true
	if xinput != 0 and is_on_floor():
		run = true
		
	if land:
		var land_instance = fx_land.instance()
		land_instance.modulate = c
		get_tree().get_root().get_child(0).add_child(land_instance)
		land_instance.set_emitting(true)
		land_instance.global_position = particleAnchor.global_position
	
	"""
	if jump:
		var jump_instance = fx_jump.instance()
		jump_instance.modulate = c
		get_tree().get_root().get_child(0).add_child(jump_instance)
		jump_instance.set_emitting(true)
		jump_instance.global_position = particleAnchor.global_position
	"""
	
	if run:
		fx_foot.modulate = c
		fx_foot.set_emitting(true)
	else:
		fx_foot.set_emitting(false)
	

func move_anchor(delta):
	anchor.global_position = lerp(anchor.global_position, 
								  global_position + inputVec() * CAM_LOOK_AHEAD_AMOUNT,
								  CAM_LOOK_AHEAD_SPEED * delta)
	
func dash():
	if is_on_floor():
		canDash = true
	
	dashDir = Vector2.ZERO
	
	if Input.is_action_pressed("left"):
		dashDir = Vector2.LEFT
	elif Input.is_action_pressed("right"):
		dashDir = Vector2.RIGHT
	
	if (Input.is_action_just_pressed("dash") and canDash and 
		not is_on_floor() and not dashDir.is_equal_approx(Vector2.ZERO)):
		motion = dashDir.normalized() * DASH_SPEED
		canDash = false
		dashing = true
		yield(get_tree().create_timer(DASH_DURATION), "timeout")
		dashing = false

func animate():
	if dashing:
		animationPlayer.play("Dash")
	elif not is_on_floor():
		animationPlayer.play("Jump")
	elif xinput != 0:
		animationPlayer.play("Run")
	elif not was_on_floor and is_on_floor():
		animationPlayer.play("Land")
		animationPlayer.queue("Stand")
	elif not animationPlayer.current_animation == "Land":
		animationPlayer.play("Stand")
		
func jump(delta):
	jumping_now = false
	
	if is_on_floor():
		hangCounter = GROUND_HANG_TIME
	else:
		hangCounter -= delta
	
	if Input.is_action_just_pressed("up"):
		jumpBufferCounter = JUMP_BUFFER_TIME
	else:
		jumpBufferCounter -= delta
	
	if jumpBufferCounter >= 0 and hangCounter >= 0:
		jumping_now = true
		
		if is_on_floor():
			motion.y = -JUMP_FORCE
		jumpBufferCounter = 0
		hangCounter = 0
		

func run(delta):
	if not dashing:
		xinput = Input.get_action_strength("right") - Input.get_action_strength("left")
		
		if noMoveLeftCounter > 0:
			noMoveLeftCounter -= delta
			xinput = min(xinput, 0)
		if noMoveRightCounter > 0:
			noMoveRightCounter -= delta
			xinput = max(xinput, 0)
		
		if xinput != 0:
			motion.x += xinput * ACCELERATION * delta * TARGET_FPS
			motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
			sprite.flip_h = xinput < 0
		
func gravity(delta):
	if not dashing:
		var dy = GRAVITY * delta * TARGET_FPS
		if motion.y > 0:
			dy *= FALL_MULTIPLIER
		elif not Input.is_action_pressed("up"):
			dy *= LOW_JUMP_MULTIPLIER
			
		motion.y += dy
	
	motion.y = min(motion.y, MAX_FALL_SPEED)
	if ((is_near_left_wall() and Input.is_action_pressed("left")) 
	 or (is_near_right_wall() and Input.is_action_pressed("right"))):
		motion.y = min(motion.y, WALL_SLIDE_SPEED)

func friction(delta): 
	if not dashing:
		if is_on_floor():
			if xinput == 0:
				motion.x = lerp(motion.x, 0, FRICTION * delta)
		else:
			if xinput == 0:
				motion.x = lerp(motion.x, 0, AIR_RESISTANCE * delta)

func throw(force):
	motion = Vector2(0,-JUMP_FORCE) + force
	motion.y = max(motion.y, -JUMP_FORCE*0.9)
	if force.x < 0:
		motion.x -= JUMP_FORCE
	else:
		motion.x += JUMP_FORCE
	
func is_near_wall():
	return is_near_left_wall() or is_near_right_wall()

func is_near_left_wall():
	return $BottomLeft.is_colliding() or $TopLeft.is_colliding()

func is_near_right_wall():
	return $BottomRight.is_colliding() or $TopLeft.is_colliding()

func inputVec():
	return Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"),
				   Input.get_action_strength("down") - Input.get_action_strength("up"))

