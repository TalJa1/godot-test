extends CharacterBody2D


const SPEED = 180.0
const JUMP_VELOCITY = -300.0
@onready var container = get_node("Container")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Make animation and sprite changes.
	# Try to find an animation node safely. Supports either AnimatedSprite or AnimatedSprite2D,
	# and will silently skip if no animation node is present to avoid runtime errors.
	# Try to find an animation node safely. Supports AnimatedSprite or AnimatedSprite2D.
	# First look for a direct child, then try inside the `container` if present.
	var anim := get_node_or_null("AnimatedSprite")
	if anim == null:
		anim = get_node_or_null("AnimatedSprite2D")
	if anim == null and container:
		anim = container.get_node_or_null("AnimatedSprite")
		if anim == null:
			anim = container.get_node_or_null("AnimatedSprite2D")

	# Flip only the sprite horizontally to avoid changing container transforms
	# which can cause visual jumps if the pivot isn't centered.
	if direction != 0 and anim:
		anim.flip_h = direction < 0

	if is_on_floor():
		if direction:
			# Play the walk animation.
			if anim:
				anim.play("walk_side_b")
		else:
			# Play the idle animation.
			if anim:
				anim.play("idle_side_b")
	# else:
		# Play the jump animation.
		# if anim:
		#	anim.play("jump")

	move_and_slide()
