class_name ProjectileWeapon
extends Weapon

@export var projectile_speed = 1000
@export var projectile_damage = 3
var projectile_scene

# this is an easy solution to my state management problem without totally overhauling
# my current state design pattern. does not scale well when inheriting from this class
enum SubState { READY, COOLING }
var current_sub_state = SubState.READY


func setup(projectile_scene_in):
	projectile_scene = projectile_scene_in
	
	
# if not in cooldown, emit the projectile fired signal to be picked up by the world script
func fire_weapon_pressed(aim_direction: Vector2) -> void:
	match current_sub_state:
		SubState.READY:
			SignalBus.selected_projectile_weapon_fired.emit(self, aim_direction)
			current_sub_state = SubState.COOLING
			$FireCooldownTimer.start()
		SubState.COOLING:
			pass
	

# create a new projectile from a packed scene
# new projectile fires in aim_direction from weapon_location
func create_projectile(aim_direction: Vector2):
	var projectile = projectile_scene.instantiate() as Projectile
	projectile.setup(projectile_speed, projectile_damage, aim_direction, global_position)
	return projectile


# reset the current sub state after cooldown is finished
func _on_fire_cooldown_timer_timeout() -> void:
	current_sub_state = SubState.READY
