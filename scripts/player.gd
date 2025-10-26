extends CharacterBody2D

signal hit

var current_hp
const MAX_HP = 10.0

var move_direction = Vector2.ZERO
var move_direction_length = 0
var move_direction_angle = 0

var last_move_direction = Vector2.RIGHT
var last_move_direction_length = 0

var is_accelerating = false

var move_cardinal_direction = -1

@export var max_speed = 600 # How fast the player will move (pixels/sec).
@export var acceleration = 6

func _ready():
	current_hp = MAX_HP
	Global.player = self

	# Configure camera limits based on world bounds
	var camera = $Camera2D
	if camera:
		camera.limit_left = int(Global.WORLD_BOUNDS.position.x)
		camera.limit_top = int(Global.WORLD_BOUNDS.position.y)
		camera.limit_right = int(Global.WORLD_BOUNDS.position.x + Global.WORLD_BOUNDS.size.x)
		camera.limit_bottom = int(Global.WORLD_BOUNDS.position.y + Global.WORLD_BOUNDS.size.y)

func setup():
	# Position player at center of world
	position = Vector2(Global.WORLD_WIDTH / 2, Global.WORLD_HEIGHT / 2)
	current_hp = Global.player.MAX_HP

	# Reset camera smoothing so it snaps to player position instead of panning
	#if Global.player.has_node("Camera2D"):
		#Global.player.get_node("Camera2D").reset_smoothing()
	
	show()
	$WeaponGroup.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.game_state == Enum.GameState.TITLE_SCREEN or Global.game_state == Enum.GameState.PLAYING:
		process_input()
	process_movement(delta)
	process_animation()

# override to set the move_direction of the character
func process_input():
	move_direction = Input.get_vector("move_west", "move_east", "move_north", "move_south").normalized()
	
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

	# Clamp position to world bounds
	position.x = clamp(position.x, Global.WORLD_BOUNDS.position.x, Global.WORLD_BOUNDS.position.x + Global.WORLD_BOUNDS.size.x)
	position.y = clamp(position.y, Global.WORLD_BOUNDS.position.y, Global.WORLD_BOUNDS.position.y + Global.WORLD_BOUNDS.size.y)
	
func process_animation():
	# set animation rotation
	SpriteUtility.rotate_sprite_to_cardinal_direction($AnimatedSprite2D, move_cardinal_direction)
	
	# dying
	if current_hp <= 0.0:
		$AnimatedSprite2D.play("dying")
		$WeaponGroup.hide()
	
	# negative acceleration
	elif is_accelerating and move_direction_length == 0:
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
	
# projectile collision
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_projectile") and current_hp > 0.0:
		# free projectile
		area.queue_free()
		
		current_hp -= area.damage
		
		if current_hp <= 0:
			SignalBus.player_death.emit()
		
		emit_signal("hit", current_hp, MAX_HP)
