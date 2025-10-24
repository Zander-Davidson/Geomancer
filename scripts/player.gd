extends Character

signal hit

var current_hp
const MAX_HP = 10.0

func _ready():
	current_hp = MAX_HP
	Global.player = self

	# Configure camera limits based on world bounds
	var camera = $Camera2D
	if camera:
		camera.limit_left = int(Global.WORLD_BOUNDS.position.x)
		camera.limit_top = int(Global.WORLD_BOUNDS.position.y)
		camera.limit_right = int(Global.WORLD_BOUNDS.position.x + Global.WORLD_BOUNDS.size.x)
		camera.limit_bottom = int(Global.WORLD_BOUNDS.position.y + Global.WORLD_BOUNDS.size.y)

func process_input():
	move_direction = Input.get_vector("move_west", "move_east", "move_north", "move_south").normalized()
	super.process_input();

func on_dying():
	# TODO: Implement player death / game over logic
	# - Display game over screen
	# - Stop player movement
	# - Trigger death animation
	# - Handle respawn or scene transition
	pass

# projectile collision
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_projectile") and current_hp > 0.0:
		# free projectile
		area.queue_free()
		
		current_hp -= area.damage
		
		if current_hp <= 0:
			on_dying()
		
		emit_signal("hit", current_hp, MAX_HP)
