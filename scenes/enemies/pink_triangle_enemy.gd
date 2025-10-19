extends CardinalEnemy

const keepaway_distance = 400
const move_speed = 200

func _ready():
	max_speed = move_speed

func process_input():
	if position.distance_to(Global.player.position) > keepaway_distance:
		max_speed = move_speed
	else:
		max_speed = 0
	
	super.process_input()
