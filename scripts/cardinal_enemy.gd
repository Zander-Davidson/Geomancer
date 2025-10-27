class_name CardinalEnemy extends CharacterBody2D

signal hit

enum State { CHASING, FIRING_CHARGE, FIRING_CHARGE_HOLD, FIRING_COOLDOWN, DYING }

# Preload the projectile scene
const EYEBALL_PROJECTILE_PACKED_SCENE = preload("res://scenes/projectiles/eyeball_projectile.tscn")

@export var acceleration = 5
@export var max_hp = 10
@export var keepaway_distance = 400
@export var move_speed = 200

var max_speed = move_speed
var current_state = State.CHASING
var move_direction = MathUtility.get_direction_to_player(position)
var charge_shake_offset = Vector2.ZERO
var current_hp = max_hp


func setup(initial_position):
	position = initial_position

func _process(delta: float):
	if Global.player != null:
		match current_state:
			State.CHASING:
				process_chasing_state()
			State.FIRING_CHARGE:
				process_firing_charge_state()
			State.FIRING_CHARGE_HOLD:
				process_firing_charge_hold_state()
			State.FIRING_COOLDOWN:
				process_firing_cooldown_state()
			State.DYING:
				pass

		process_movement(delta)
		process_animation()
	
func process_movement(delta: float):
	velocity = velocity.lerp(move_direction * max_speed, acceleration * delta)
	move_and_slide()

	# Clamp position to world bounds
	position.x = clamp(position.x, Global.WORLD_BOUNDS.position.x, Global.WORLD_BOUNDS.position.x + Global.WORLD_BOUNDS.size.x)
	position.y = clamp(position.y, Global.WORLD_BOUNDS.position.y, Global.WORLD_BOUNDS.position.y + Global.WORLD_BOUNDS.size.y)
	
# set animation to one of 8 cardinal direction animations
func process_animation():
	# Get the cardinal direction based on move_direction
	var move_cardinal_direction = MathUtility.get_cardinal_direction(move_direction)

	match current_state:
		State.CHASING:
			# Use parent's normal animation logic
			if max_speed > 0:
				$AnimatedSprite2D.play("moving_" + str(move_cardinal_direction))
			else:
				$AnimatedSprite2D.play("idle_" + str(move_cardinal_direction))

		State.FIRING_CHARGE:
			# Play firing animation, tracking player direction
			$AnimatedSprite2D.play("firing_" + str(move_cardinal_direction))
				
		State.FIRING_CHARGE_HOLD:
			# undo the last shake offset, add add a new one
			position -= charge_shake_offset
			charge_shake_offset = SpriteUtility.shake_sprite(5)
			position += charge_shake_offset
			
			# hold the final frame of the firing anmiation
			$AnimatedSprite2D.frame = 3
			$AnimatedSprite2D.play("firing_" + str(move_cardinal_direction))

		State.FIRING_COOLDOWN:
			# Play idle animation, still tracking player direction
			$AnimatedSprite2D.play("idle_" + str(move_cardinal_direction))
		
		State.DYING:
			$AnimatedSprite2D.play("dying")
			
func process_chasing_state():
	move_direction = MathUtility.get_direction_to_player(position)
	
	# Normal chase behavior
	if position.distance_to(Global.player.position) <= keepaway_distance:
		# Within stopping range - start firing sequence
		max_speed = 0
		current_state = State.FIRING_CHARGE
		$FiringChargeTimer.start()

func process_firing_charge_state():
	# Update direction to player (but don't move)
	move_direction = MathUtility.get_direction_to_player(position)

func process_firing_charge_hold_state():
	# Update direction to player (but don't move)
	move_direction = MathUtility.get_direction_to_player(position)

func process_firing_cooldown_state():
	# Continue tracking player direction
	move_direction = MathUtility.get_direction_to_player(position)

func fire_projectile():
	# Spawn projectile at enemy position, shooting toward player
	var projectile = EYEBALL_PROJECTILE_PACKED_SCENE.instantiate()
	projectile.setup(750, 1, MathUtility.get_direction_to_player(position), position)
	get_parent().add_child(projectile)
			
func _on_firing_charge_timer_timeout() -> void:
	if current_state != State.DYING:	
		# Fire the projectile after charge-up completes
		current_state = State.FIRING_CHARGE_HOLD
		$FiringChargeHoldTimer.start() # Replace with function body.

func _on_firing_charge_hold_timer_timeout() -> void:
	if current_state != State.DYING:
		current_state = State.FIRING_COOLDOWN
		
		# reset position and shake offset
		position -= charge_shake_offset
		charge_shake_offset = Vector2.ZERO
		
		fire_projectile()
		$FiringCooldownTimer.start()

func _on_firing_cooldown_timer_timeout() -> void:
	if current_state != State.DYING:
		# Return to chasing after cooldown
		current_state = State.CHASING
		max_speed = move_speed
		
# projectile collision
func _on_hitbox_entered(projectile: Area2D) -> void:
	if projectile.is_in_group("player_projectile") and current_hp > 0.0:
		# free projectile
		projectile.queue_free()
		
		current_hp -= projectile.damage
		
		if current_hp <= 0:
			_on_dying()
		
		emit_signal("hit", current_hp, max_hp)

# dying but not freed
func _on_dying():
	current_state = State.DYING
	current_hp = 0.0
	max_speed = 0
	$DyingAnimationTimer.start()
	Global.num_enemies_killed += 1
	SignalBus.enemy_killed.emit()
	
# free enemy after dying animation
func _on_dying_animation_timer_timeout() -> void:
	queue_free()
