extends Path2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Keep spawn rectangle centered on player
	position.x = Global.player.global_position.x  - 500
	position.y = Global.player.global_position.x  - 500
