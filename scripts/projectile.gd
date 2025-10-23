class_name Projectile extends CollisionObject2D

@export var damage = 1
@export var max_speed = 10
var move_direction
var move_cardinal_direction

func setup(max_speed_in, damage_in, move_direction_in, initial_position):
	move_direction = move_direction_in
	move_cardinal_direction = MathUtility.get_cardinal_direction(move_direction)
	max_speed = max_speed_in
	damage = damage_in
	position = initial_position

func _process(delta: float) -> void:
	process_movement(delta)
	process_animation()
	
func process_movement(delta: float):
	position += move_direction * max_speed * delta

	# Clean up projectile when completely outside world bounds
	# Buffer zone accounts for sprite size (~200px max)
	# Note: grow() returns a new Rect2, doesn't modify Global.WORLD_BOUNDS
	var buffer = 200
	var cleanup_bounds = Global.WORLD_BOUNDS.grow(buffer)
	if not cleanup_bounds.has_point(position):
		queue_free()

func process_animation():
	# set animation rotation
	SpriteUtility.rotate_sprite_to_cardinal_direction($AnimatedSprite2D, move_cardinal_direction)
		
	# moving at full speed
	if move_direction.length() > 0:
		SpriteUtility.set_sprite_moving_animation($AnimatedSprite2D, move_cardinal_direction)
	# idle
	else:
		SpriteUtility.set_sprite_idle_animation($AnimatedSprite2D)
