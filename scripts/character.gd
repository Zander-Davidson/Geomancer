class_name Character extends CharacterBody2D

var move_direction = Vector2.ZERO
var move_direction_length = 0
var move_direction_angle = 0

var last_move_direction = Vector2.ZERO
var last_move_direction_length = 0

var move_animation = "idle"

var is_accelerating = false

var move_cardinal_direction = -1

@export var max_speed = 600 # How fast the player will move (pixels/sec).
@export var acceleration = 6
var screen_size # Size of the game window.

func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	process_input()
	process_movement(delta)
	process_animation()

# override to set the move_direction of the character
func process_input():
	if move_direction.length() != 0:
		last_move_direction = move_direction
	last_move_direction_length = move_direction_length
	
	move_direction_angle = move_direction.angle()
	move_direction_length = move_direction.length()
	
	move_cardinal_direction = MathUtility.get_cardinal_direction(last_move_direction)
	
	# decelerating
	if move_direction_length == 0 and last_move_direction_length > 0:
		$RampTimer.start()
		is_accelerating = true
		
	# accelerating
	elif move_direction_length > 0 and last_move_direction_length == 0:
		$RampTimer.start()
		is_accelerating = true
	
func process_movement(delta: float):
	velocity = velocity.lerp(move_direction * max_speed, acceleration * delta)
	move_and_slide()

	position = position.clamp(Vector2.ZERO, screen_size)
	
func process_animation():
	# set animation rotation
	SpriteUtility.rotate_sprite_to_cardinal_direction($AnimatedSprite2D, move_cardinal_direction)
	
	# negative acceleration
	if is_accelerating and move_direction_length == 0:
		SpriteUtility.set_sprite_decelerating_animation($AnimatedSprite2D, move_cardinal_direction)
	
	# positive acceleration
	elif is_accelerating and move_direction_length > 0:
		SpriteUtility.set_sprite_accelerating_animation($AnimatedSprite2D, move_cardinal_direction)
		
	# moving at full speed
	elif move_direction_length > 0 and not is_accelerating:
		SpriteUtility.set_sprite_moving_animation($AnimatedSprite2D, move_cardinal_direction)
			
	# idle
	elif move_direction_length == 0 and not is_accelerating:
		SpriteUtility.set_sprite_idle_animation($AnimatedSprite2D)

func _on_ramp_timer_timeout() -> void:
	is_accelerating = false
