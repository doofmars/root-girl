extends KinematicBody2D

const WALK_FORCE = 5000
const WALK_MAX_SPEED = 500
const STOP_FORCE = 5000
const JUMP_SPEED = 300

var velocity = Vector2()
var facingRight = true

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	set_meta('type', 'girl')

func _physics_process(delta):
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

func _on_Liana_swing(delta:float, liana_target:Vector2, liana_length:float):
	if (liana_target - global_position).length() > liana_length:
		position += (liana_target - global_position).normalized() * delta * 800
	if (liana_target - global_position).length() < liana_length:
		position += (global_position - liana_target).normalized() * delta * 500