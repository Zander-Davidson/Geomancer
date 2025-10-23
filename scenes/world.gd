extends Node

func _ready():
	SignalBus.selected_weapon_fired.connect(_on_selected_weapon_fired)

	# Position player at center of world
	if has_node("Player"):
		var player = get_node("Player")
		player.position = Vector2(Global.WORLD_WIDTH / 2, Global.WORLD_HEIGHT / 2)

		# Reset camera smoothing so it snaps to player position instead of panning
		if player.has_node("Camera2D"):
			player.get_node("Camera2D").reset_smoothing()
	
func _on_selected_weapon_fired(weapon: Weapon, aim_direction: Vector2, weapon_location: Vector2):
	add_child(weapon.create_projectile(aim_direction, weapon_location))
