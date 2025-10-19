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
