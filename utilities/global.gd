extends Node

static var player = null
static var num_enemies_killed
static var seconds_elapsed
static var game_state

# World bounds configuration
const WORLD_WIDTH = 4000
const WORLD_HEIGHT = 4000
const WORLD_BOUNDS = Rect2(0, 0, WORLD_WIDTH, WORLD_HEIGHT)
