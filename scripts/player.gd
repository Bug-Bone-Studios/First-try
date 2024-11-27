extends CharacterBody2D

var can_jetpack = GameManager.can_jetpack
var thrust_amount = 5 # Max thrust
var current_health: int = 3

const SPEED = 130.0
const JUMP_VELOCITY = -250.0

@onready var jetpack_noise: AudioStreamPlayer2D = $AnimatedSprite2D/AudioStreamPlayer2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D	

func _ready() -> void:
	print("Scene 1 is ready")
	can_jetpack = GameManager.can_jetpack

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction: -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	# Flip the Sprite.
	if direction > 0:
		animated_sprite.flip_h = false
	if direction < 0:
		animated_sprite.flip_h = true
		
	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	# Apply movement.
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	apply_jetpack(delta)
	move_and_slide()

func apply_jetpack(delta):
	if can_jetpack:
		if not is_on_floor():
			if thrust_amount > 0:
				if Input.is_action_pressed("boost"):
					# Play animation
					animated_sprite.play("thrusting")
					if animated_sprite.is_playing() == true:
						jetpack_noise.playing = true
					# Decrease thrust amount
					thrust_amount -= 20 * delta
					velocity.y -= 20  # Apply upward force for jetpack
					
					# Optional: Play jetpack sound or effect here
					print("Thrusting with amount: ", thrust_amount)

		elif is_on_floor():
			can_jetpack = true
			thrust_amount = 5
