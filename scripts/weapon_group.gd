extends Node2D

const FOV_ANGLE = PI / 8  # 45 degree cone on each side of aim direction
const AIM_ASSIST_ROTATION_SPEED = 8.0  # How fast auto-aim rotates towards target (radians/sec)

var aim_direction = Vector2(0,1)
var nearby_enemies: Array = []

var weapons = []
var selected_weapon_index

var target_rotation_offset 	= 0.0  # Target angle offset for all orbitals
var current_rotation_offset = 0.0  # Current smoothed angle offset
var rotation_velocity = 0.0  # Angular velocity for smooth movement
var is_rotating = false

# Rotation parameters - adjust these to taste
var max_rotation_speed = 20.0  # Maximum radians per second
var rotation_acceleration = 35.0  # How fast we accelerate
var rotation_deceleration = 25.0  # How fast we decelerate when near target

func _ready():
	# TODO: remove and implement weapon pickups
	var w1 = preload("res://scenes/weapons/red_minus_weapon.tscn").instantiate()
	var w2 = preload("res://scenes/weapons/purple_plus_weapon.tscn").instantiate()
	w2.setup(preload("res://scenes/projectiles/purple_plus_projectile.tscn"))
	var w3 = preload("res://scenes/weapons/blue_divide_weapon.tscn").instantiate()
	var w4 = preload("res://scenes/weapons/purple_plus_weapon.tscn").instantiate()
	w4.setup(preload("res://scenes/projectiles/purple_plus_projectile.tscn"))
	
	w1.is_selected = true
	selected_weapon_index = 0
	
	add_child(w1)
	add_child(w2)
	add_child(w3)
	add_child(w4)
	
	weapons.push_front(w4)
	weapons.push_front(w3)
	weapons.push_front(w2)
	weapons.push_front(w1)

func _process(delta: float) -> void:
	process_input(delta)

	# Smooth rotation
	smooth_rotation(delta)

	# Update positions
	process_movement(delta)

func process_input(delta: float):
	match Settings.get_setting("controls", "control_mode"):

		# aiming is different depending on control mode
		Enum.ControlMode.GAMEPAD:
			var stick_direction = Input.get_vector("aim_west", "aim_east", "aim_north", "aim_south").normalized()
			if stick_direction.length() != 0:
				aim_direction = auto_aim(stick_direction, delta)
			else:
				aim_direction = Global.player.last_move_direction
				
		Enum.ControlMode.MOUSE_AND_KEYBOARD:
			var mouse_position = get_global_mouse_position()
			aim_direction = (mouse_position - global_position).normalized()

	# control mode agnostic settings
	
	# cycle next weapon
	if Input.is_action_just_pressed("cycle_weapon") and weapons.size() > 1:
		cycle_weapons_counter_clockwise()
			
	# fire weapon
	if Input.is_action_just_pressed("fire_weapon"):
		var selected_weapon = weapons[selected_weapon_index]
		SignalBus.selected_weapon_fired.emit(
			selected_weapon, 
			aim_direction, 
			global_position + aim_direction * selected_weapon.distance_from_parent)

func cycle_weapons_counter_clockwise():
	weapons[selected_weapon_index].is_selected = false
	
	# Move to the next weapon
	selected_weapon_index = (selected_weapon_index + 1) % weapons.size()
		
	weapons[selected_weapon_index].is_selected = true
	
	# Add one arc segment to the target rotation
	var arc_angle = 2 * PI / weapons.size()
	target_rotation_offset = arc_angle
	is_rotating = true

func smooth_rotation(delta: float):
	if not is_rotating:
		return
	
	# Calculate the angle difference
	var angle_diff = target_rotation_offset - current_rotation_offset
	
	# Check if we're close enough to stop (increased thresholds)
	if abs(angle_diff) < 0.001 and abs(rotation_velocity) < 0.01:
		stop_rotation()
		return
	
	# Apply acceleration or deceleration
	var distance_to_target = abs(angle_diff)
	var decel_distance = (rotation_velocity * rotation_velocity) / (2 * rotation_deceleration)
	
	if distance_to_target > decel_distance and abs(rotation_velocity) < max_rotation_speed:
		# Accelerate
		rotation_velocity += rotation_acceleration * delta * sign(angle_diff)
		rotation_velocity = clamp(rotation_velocity, -max_rotation_speed, max_rotation_speed)
	else:
		# Decelerate
		var decel_amount = rotation_deceleration * delta
		if abs(rotation_velocity) > decel_amount:
			rotation_velocity -= decel_amount * sign(rotation_velocity)
		else:
			rotation_velocity = 0
	
	# Apply velocity
	current_rotation_offset += rotation_velocity * delta
	
	# Snap to target if very close (helps prevent shaking)
	if abs(target_rotation_offset - current_rotation_offset) < 0.05:
		stop_rotation()

func stop_rotation():
	target_rotation_offset = 0.0
	current_rotation_offset = 0.0
	rotation_velocity = 0.0
	is_rotating = false

func process_movement(delta: float):
	if weapons.size() == 0:
		return

	var num_weapons = weapons.size()
	var arc_angle = 2 * PI / num_weapons

	# Use target offset when not rotating to prevent jitter from aim_direction changes
	var angle_offset = 0 if not is_rotating else (current_rotation_offset - arc_angle)

	for i in range(selected_weapon_index, num_weapons):
		weapons[i].position = aim_direction.rotated(angle_offset) * weapons[i].distance_from_parent
		angle_offset -= arc_angle
	for i in range(0, selected_weapon_index):
		weapons[i].position = aim_direction.rotated(angle_offset) * weapons[i].distance_from_parent
		angle_offset -= arc_angle

func _on_aim_assist_area_entered(area: Area2D) -> void:
	if area.is_in_group("aim_assist_target"):
		var enemy = area.get_parent()
		if enemy and not nearby_enemies.has(enemy):
			nearby_enemies.append(enemy)

func _on_aim_assist_area_exited(area: Area2D) -> void:
	if area.is_in_group("aim_assist_target"):
		var enemy = area.get_parent()
		if enemy and nearby_enemies.has(enemy):
			nearby_enemies.erase(enemy)

func auto_aim(stick_direction: Vector2, delta: float) -> Vector2:
	var current_aim = aim_direction
	var closest_enemy = null
	var closest_distance = INF

	# Find closest enemy within FOV
	for enemy in nearby_enemies:
		# Skip if enemy was freed
		if not is_instance_valid(enemy):
			continue

		var direction_to_enemy = (enemy.global_position - global_position).normalized()
		var distance_to_enemy = global_position.distance_to(enemy.global_position)

		# Check if enemy is within FOV
		var angle_to_enemy = direction_to_enemy.angle()
		var current_aim_angle = current_aim.angle()
		var angle_diff = abs(angle_to_enemy - current_aim_angle)

		# Handle angle wraparound
		if angle_diff > PI:
			angle_diff = 2 * PI - angle_diff

		# Enemy is in FOV and closer than current closest and enemy not DYING
		if enemy.current_state != CardinalEnemy.State.DYING and angle_diff <= FOV_ANGLE and distance_to_enemy < closest_distance:
			closest_enemy = enemy
			closest_distance = distance_to_enemy

	# Smoothly rotate towards target or stick direction
	var target_direction: Vector2
	if closest_enemy:
		target_direction = (closest_enemy.global_position - global_position).normalized()

		# Check if player is manually aiming outside FOV of auto-aim target
		var angle_to_target = target_direction.angle()
		var stick_angle = stick_direction.angle()
		var stick_to_target_diff = abs(stick_angle - angle_to_target)

		# Handle angle wraparound
		if stick_to_target_diff > PI:
			stick_to_target_diff = 2 * PI - stick_to_target_diff

		# If stick is outside FOV of target, use stick direction instead
		if stick_to_target_diff > FOV_ANGLE:
			target_direction = stick_direction
	else:
		target_direction = stick_direction

	# Calculate angle difference and rotate smoothly
	var current_angle = current_aim.angle()
	var target_angle = target_direction.angle()
	var angle_diff = target_angle - current_angle

	# Normalize angle difference to [-PI, PI]
	while angle_diff > PI:
		angle_diff -= 2 * PI
	while angle_diff < -PI:
		angle_diff += 2 * PI

	# Calculate how much to rotate this frame
	var max_rotation_this_frame = AIM_ASSIST_ROTATION_SPEED * delta
	var rotation_amount = clamp(angle_diff, -max_rotation_this_frame, max_rotation_this_frame)

	# Apply rotation and return new direction
	return current_aim.rotated(rotation_amount)
