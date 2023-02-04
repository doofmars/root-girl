class_name Girl
extends KinematicBody2D

const WALK_FORCE = 5000
const WALK_MAX_SPEED = 500
const STOP_FORCE = 5000
const JUMP_SPEED = 300

const SWING_FORCE = 100
const MAX_SWING_SPEED = 600

var velocity = Vector2()
var facingRight = true

var attached_to_swing = false
var swing_target := Vector2(0,0)

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	set_meta('type', 'girl')

func _physics_process(delta):
	if attached_to_swing:
		swing_movement(delta)
	else:
		normal_movement(delta)

func normal_movement(delta):
	# Horizontal movement code. First, get the player's input.
	var walk = WALK_FORCE * (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	# Slow down the player if they're not trying to move.
	if abs(walk) < WALK_FORCE * 0.2:
		# The velocity, slowed down a bit, and then reassigned.
		velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta)
	else:
		velocity.x += walk * delta
	# Clamp to the maximum horizontal movement speed.
	velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)

	# Vertical movement code. Apply gravity.
	velocity.y += gravity * delta

	# Move based on the velocity and snap to the ground.
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2 .UP)

	# Check for jumping. is_on_floor() must be called after movement code.
	if is_on_floor() and Input.is_action_just_pressed("ui_up"):
		velocity.y = -JUMP_SPEED

	if (velocity.x < 0):
		facingRight = false
	elif (velocity.x > 0):
		facingRight = true
	$AnimatedSprite.flip_h = not facingRight
	if (is_on_floor()):
		if (velocity.x == 0):
			$AnimatedSprite.animation = "idle"
		else:
			$AnimatedSprite.animation = "run"
	else:
		$AnimatedSprite.animation = "fall"

	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.is_in_group("hazard"):
			get_parent().notify_player_death()
			break

func swing_movement(delta):
	if Input.get_action_strength("ui_right") > 0:
		velocity += (swing_target - global_position).normalized().rotated(PI/4) * SWING_FORCE;
	if Input.get_action_strength("ui_left") > 0:
		velocity += (swing_target - global_position).normalized().rotated(-PI/4) * SWING_FORCE;

	velocity.x = clamp(velocity.x, -MAX_SWING_SPEED, MAX_SWING_SPEED)
	velocity.y = clamp(velocity.y, -MAX_SWING_SPEED, MAX_SWING_SPEED)
	velocity = move_and_slide(velocity)

	if (velocity.x < 0):
		facingRight = false
	elif (velocity.x > 0):
		facingRight = true
	$AnimatedSprite.flip_h = not facingRight

func _on_RootSwing_detach():
	attached_to_swing = false


func _on_RootSwing_attach(root_target:Vector2, _root_length:float):
	attached_to_swing = true
	swing_target = root_target
