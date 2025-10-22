class_name Weapon extends Node2D

@export var distance_from_parent = 50
var is_selected = false
var projectile_scene

func setup(projectile_scene_in):
	projectile_scene = projectile_scene_in
	
func create_projectile(aim_direction: Vector2, weapon_location: Vector2):
	var projectile = projectile_scene.instantiate() as Projectile
	projectile.setup(1000, 3, aim_direction, weapon_location)
	return projectile

func _process(delta: float):
	process_animation()
	
func process_animation():
	if is_selected:
		$AnimatedSprite2D.play("selected")
		$AnimatedSprite2D.scale = Vector2(0.4, 0.4)
	else:
		$AnimatedSprite2D.play("not_selected")
		$AnimatedSprite2D.scale = Vector2(0.2, 0.2)
