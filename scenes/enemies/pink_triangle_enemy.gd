extends CardinalEnemy

const keepaway_distance = 400
const move_speed = 200

# Preload the projectile scene
const EyeballProjectile = preload("res://scenes/projectiles/eyeball_projectile.tscn")

# State machine
enum State { CHASING, FIRING_CHARGE, FIRING_CHARGE_HOLD, FIRING_COOLDOWN }
var current_state = State.CHASING
var charge_shake_offset = Vector2.ZERO

func _ready():
	max_speed = move_speed
	# TODO: make this a utility function
	move_direction = MathUtility.get_direction_to_player(position)

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

		process_movement(delta)
		process_animation()

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
	var projectile = EyeballProjectile.instantiate()
	projectile.setup(750, 1, MathUtility.get_direction_to_player(position), position)
	get_parent().add_child(projectile)

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
			var offset = SpriteUtility.shake_sprite(5)
			position += offset
			charge_shake_offset += offset
			$AnimatedSprite2D.frame = 3
			$AnimatedSprite2D.play("firing_" + str(move_cardinal_direction))

		State.FIRING_COOLDOWN:
			# Play idle animation, still tracking player direction
			$AnimatedSprite2D.play("idle_" + str(move_cardinal_direction))

func _on_firing_charge_timer_timeout() -> void:
	# Fire the projectile after charge-up completes
	current_state = State.FIRING_CHARGE_HOLD
	$FiringChargeHoldTimer.start() # Replace with function body.

func _on_firing_charge_hold_timer_timeout() -> void:
	current_state = State.FIRING_COOLDOWN
	position -= charge_shake_offset
	charge_shake_offset = Vector2.ZERO
	fire_projectile()
	$FiringCooldownTimer.start() # Replace with function body.

func _on_firing_cooldown_timer_timeout() -> void:
	# Return to chasing after cooldown
	current_state = State.CHASING
	max_speed = move_speed
