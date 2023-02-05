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

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
onready var root_handle: RootHandle = get_tree().root.find_node("RootHandle", true, false)
onready var root_anchor: StaticBody2D = get_tree().root.find_node("RootAnchor", true, false)
onready var root_joint: PinJoint2D = get_tree().root.find_node("RootJoint", true, false)

func _ready():
	set_meta('type', 'girl')

func _physics_process(delta):
	if attached_to_swing and Input.is_action_just_pressed("move_up"):
		velocity.y = -JUMP_SPEED
		get_node("RootSwing").detach_root()
	root_handle.update_position = not attached_to_swing
	root_handle.desired_position = global_position
	if attached_to_swing:
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
	velocity = root_handle.linear_velocity
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
	root_joint.node_b = root_anchor.get_path()
	attached_to_swing = false


func _on_RootSwing_attach(root_target:Vector2, _root_length:float):
	root_anchor.global_position = root_target
	root_joint.global_position = root_target
	root_joint.node_b = root_handle.get_path()
	attached_to_swing = true
