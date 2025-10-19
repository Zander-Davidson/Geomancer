extends Node2D

var aim_direction = Vector2(0,1)

var weapons = []
var selected_weapon_index

var target_rotation_offset = 0.0  # Target angle offset for all orbitals
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
	process_input()
	
	# Smooth rotation
	smooth_rotation(delta)
	
	# Update positions
	process_movement(delta)

	
func process_input():
	# aiming
	var stick_direction = Input.get_vector("aim_west", "aim_east", "aim_north", "aim_south").normalized()
	if stick_direction.length() != 0:
		aim_direction = stick_direction

	# weapon cycling
	if Input.is_action_just_pressed("cycle_weapon") and weapons.size() > 1:
		cycle_weapons_counter_clockwise()

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
