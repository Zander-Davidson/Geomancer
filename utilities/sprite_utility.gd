extends Node

func set_sprite_idle_animation(sprite):
	sprite.play("idle")

func set_sprite_moving_animation(sprite, cardinal_direction):
	if cardinal_direction in [0, 2, 4, 6]:
		sprite.play("moving")
	else:
		sprite.play("moving_diagonal")
			
func set_sprite_accelerating_animation(sprite, cardinal_direction):
	if cardinal_direction in [0, 2, 4, 6]:
		sprite.play("ramp_up")
	else:
		sprite.play("ramp_up_diagonal")
	
func set_sprite_decelerating_animation(sprite, cardinal_direction):
	if cardinal_direction in [0, 2, 4, 6]:
		sprite.play_backwards("ramp_up")
	else:
		sprite.play_backwards("ramp_up_diagonal")

func rotate_sprite_to_cardinal_direction(sprite, cardinal_direction):
	match cardinal_direction:
		Enum.CardinalDirection.EAST:
			sprite.rotation = PI/2
		Enum.CardinalDirection.NORTH_EAST:
			sprite.rotation = 0
		Enum.CardinalDirection.NORTH:
			sprite.rotation = 0
		Enum.CardinalDirection.NORTH_WEST:
			sprite.rotation = -PI/2
		Enum.CardinalDirection.WEST:
			sprite.rotation = -PI/2
		Enum.CardinalDirection.SOUTH_WEST:
			sprite.rotation = PI
		Enum.CardinalDirection.SOUTH:
			sprite.rotation = PI
		Enum.CardinalDirection.SOUTH_EAST:
			sprite.rotation = PI/2

func shake_sprite(magnitude: float):
	"""
	Applies a random offset to the sprite's position for a shaking effect.

	Args:
		magnitude: The maximum pixel displacement in any direction

	Returns:
		A random offset Vector2 for shaking effect
	"""
	var offset_x = randf_range(-magnitude, magnitude)
	var offset_y = randf_range(-magnitude, magnitude)
	return Vector2(offset_x, offset_y)

func get_gradient_color(color_from: Color, color_to: Color, t: float) -> Color:
	"""
	Returns a color along a smooth gradient between two colors.

	Args:
		color_from: The starting color (corresponds to t = 0.0)
		color_to: The ending color (corresponds to t = 1.0)
		t: The interpolation factor from 0.0 (color_from) to 1.0 (color_to)

	Returns:
		A Color object interpolated between color_from and color_to
	"""

	# Interpolate each color component including alpha
	return Color(
		lerp(color_from.r, color_to.r, t),
		lerp(color_from.g, color_to.g, t),
		lerp(color_from.b, color_to.b, t),
		lerp(color_from.a, color_to.a, t)
	)
