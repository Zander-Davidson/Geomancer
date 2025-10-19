extends Node2D

func _ready():
	SignalBus.selected_weapon_fired.connect(_on_selected_weapon_fired)
	
func _on_selected_weapon_fired(weapon: Weapon, aim_direction: Vector2, weapon_location):
	var projectile = weapon.projectile_scene.instantiate() as Projectile
	projectile.setup(500, aim_direction, weapon_location)
	add_child(projectile)
