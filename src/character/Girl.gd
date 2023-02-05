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

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
onready var the_root: TheRoot = get_tree().root.find_node("TheRoot", true, false)

func _ready():
	set_meta('type', 'girl')

func _physics_process(delta):
	if the_root.is_attached() and Input.is_action_just_pressed("move_up"):
		velocity.y = -JUMP_SPEED
		get_node("RootSwing").detach_root()
	the_root.on_player_move(global_position)
	if the_root.is_attached():
		swing_movement(delta)
	else:
		normal_movement(delta)

func normal_movement(delta):
	# Horizontal movement code. First, get the player's input.
	var walk = WALK_FORCE * (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
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
	if is_on_floor() and Input.is_action_just_pressed("move_up"):
		velocity.y = -JUMP_SPEED
		if !$JumpPlayer.playing:
			$JumpPlayer.playing = true

	update_character_after_movement()

func swing_movement(delta):
	velocity = the_root.get_handle_velocity()
	velocity = move_and_slide(velocity)

	update_character_after_movement()

func update_character_after_movement():
	if (velocity.x < 0):
		facingRight = false
	elif (velocity.x > 0):
		facingRight = true
	$AnimatedSprite.flip_h = not facingRight
	if (is_on_floor()):
		if (velocity.x == 0):
			$AnimatedSprite.animation = "idle"
			$StepPlayer.playing = false
		else:
			$AnimatedSprite.animation = "run"
			if !$StepPlayer.playing:
				$StepPlayer.playing = true
	else:
		$AnimatedSprite.animation = "fall"
		$StepPlayer.playing = false
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.is_in_group("hazard"):
			$OuchPlayer.play(0)
			get_parent().notify_player_death()
			break

func _on_RootSwing_detach():
	the_root.detach()


func _on_RootSwing_attach(root_target:Vector2, _root_length:float):
	the_root.attach(root_target)
