extends KinematicBody2D

const TARGET_FPS = 60
const ACCELERATION = 16
const MAX_SPEED = 100
const FRICTION = 24
const AIR_RESISTANCE = 2
const WALL_SLIDE_SPEED = 50
const DASH_SPEED = 175
const DASH_DURATION = 0.2

const JUMP_FORCE = 190
const WALL_JUMP_FORCE = 140
const MAX_FALL_SPEED = 400
const GRAVITY = 6
const FALL_MULTIPLIER = 2.5
const LOW_JUMP_MULTIPLIER = 3.5

const GROUND_HANG_TIME = 0
const WALL_HANG_TIME = 0.2
const JUMP_BUFFER_TIME = 0.25

const CAM_LOOK_AHEAD_SPEED = 6
const CAM_LOOK_AHEAD_AMOUNT = 50

const NO_MOVE_LEFT_TIME = 0.25
const NO_MOVE_RIGHT_TIME = 0.25

var hangCounter = 0
var jumpBufferCounter = 0

var noMoveLeftCounter = 0
var noMoveRightCounter = 0

var xinput = 0
var motion = Vector2.ZERO

var canDash = false
var dashDir = Vector2.ZERO
var dashing = false

var jumpingNow = false
var player_on_top = null
var was_on_floor = true

onready var sprite = get_node("Sprite")
onready var animationPlayer = get_node("AnimPlayer")
onready var anchor = get_node("../Anchor")
onready var parent = get_owner()

var can_move = true
var is_controlled = true

func _physics_process(delta):
	
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
	
		close_down()
		motion = move_and_slide(motion, Vector2.UP)
	if player_on_top != null:
		var pos = get_global_position() + Vector2(0, -16)
		player_on_top.set_global_position(pos)
		player_on_top.sprite.flip_h = sprite.flip_h


func close_down():
	was_on_floor = is_on_floor()

func particles():
	var land = false
	var jump = false
	var run = false
	if not was_on_floor and is_on_floor():
		land = true
	if jumpingNow:
		jump = true
	if xinput != 0 and is_on_floor():
		run = true
	


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
	else:
		animationPlayer.play("Stand")
		
func jump(delta):
	jumpingNow = false
	
	if is_on_floor():
		hangCounter = GROUND_HANG_TIME
	elif is_near_wall():
		hangCounter = WALL_HANG_TIME
	else:
		hangCounter -= delta
	
	if Input.is_action_just_pressed("up"):
		jumpBufferCounter = JUMP_BUFFER_TIME
	else:
		jumpBufferCounter -= delta
	
	if jumpBufferCounter >= 0 and hangCounter >= 0:
		jumpingNow = true
		
		if is_on_floor():
			motion.y = -JUMP_FORCE
		else:
			motion.y = -WALL_JUMP_FORCE
		jumpBufferCounter = 0
		hangCounter = 0
		if not is_on_floor() and is_near_left_wall():
			motion.x = MAX_SPEED
			noMoveRightCounter = NO_MOVE_RIGHT_TIME
		elif not is_on_floor() and is_near_right_wall():
			motion.x = -MAX_SPEED
			noMoveLeftCounter = NO_MOVE_LEFT_TIME

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

func throw():
	motion = Vector2(JUMP_FORCE, -JUMP_FORCE)
	if sprite.flip_h:
		motion.x = -motion.x

func is_near_wall():
	return is_near_left_wall() or is_near_right_wall()

func is_near_left_wall():
	return $BottomLeft.is_colliding() or $TopLeft.is_colliding()

func is_near_right_wall():
	return $BottomRight.is_colliding() or $TopLeft.is_colliding()

func inputVec():
	return Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"),
				   Input.get_action_strength("down") - Input.get_action_strength("up"))

