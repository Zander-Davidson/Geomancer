extends Node

func _ready():
	SignalBus.selected_weapon_fired.connect(_on_selected_weapon_fired)
	
func _on_selected_weapon_fired(weapon: Weapon, aim_direction: Vector2, weapon_location: Vector2):
	add_child(weapon.create_projectile(aim_direction, weapon_location))
