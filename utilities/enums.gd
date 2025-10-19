# to avoid lengthy match statements when choosing an animation on cardinal direction,
# postfix the EAST animation with "_0", the NORTH_EAST animation with "_1", and so on
# going counter-clockwise around the compass. then interpolate the animation name
# string with the node's cardinal direction to choose the right animation.
# (e.g. "idle_5" should give the animation that faces southwest)

enum CardinalDirection {
	EAST,
	NORTH_EAST,
	NORTH,
	NORTH_WEST,
	WEST,
	SOUTH_WEST,
	SOUTH,
	SOUTH_EAST
}
