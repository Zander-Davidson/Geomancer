extends Node

# calculate cardinal direction from a vector
func get_cardinal_direction(vector):
	var angle = vector.angle()

	if PI/8 > angle and angle >= -PI/8:
		return Enum.CardinalDirection.EAST
	elif -PI/8 > angle and angle >= -3*PI/8:
		return Enum.CardinalDirection.NORTH_EAST
	elif -3*PI/8 > angle and angle >= -5*PI/8:
		return Enum.CardinalDirection.NORTH
	elif -5*PI/8 > angle and angle >= -7*PI/8:
		return Enum.CardinalDirection.NORTH_WEST
	elif -7*PI/8 > angle or angle >= 7*PI/8:
		return Enum.CardinalDirection.WEST
	elif 7*PI/8 > angle and angle >= 5*PI/8:
		return Enum.CardinalDirection.SOUTH_WEST
	elif 5*PI/8 > angle and angle >= 3*PI/8:
		return Enum.CardinalDirection.SOUTH
	elif 3*PI/8 > angle and angle >= PI/8:
		return Enum.CardinalDirection.SOUTH_EAST
