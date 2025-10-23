extends Character

signal hit

var current_hp
const MAX_HP = 10.0

func _ready():
	super._ready()
	current_hp = MAX_HP
	Global.player = self

func process_input():
	move_direction = Input.get_vector("move_west", "move_east", "move_north", "move_south").normalized()
	super.process_input();

func on_dying():
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
