extends Character

func _ready():
	super._ready()
	Global.player = self

func process_input():
	move_direction = Input.get_vector("move_west", "move_east", "move_north", "move_south").normalized()
	super.process_input();
