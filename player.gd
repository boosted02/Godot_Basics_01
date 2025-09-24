extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -250.0
const DASH_VELOCITY = 400
var dashing: = false
var can_dash: = true


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("Dash") and can_dash:
		dashing = true
		can_dash = false
		($Dash_Timer as Timer).start()
		($dash_again_Timer as Timer).start()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		if dashing:
			velocity.x = direction * DASH_VELOCITY
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

# Dashing Timer so we don't stay in dash state.
func _on_dash_timer_timeout() -> void:
	dashing = false

# Prevent Dashing again and again.
func _on_dash_again_timer_timeout() -> void:
	can_dash = true
