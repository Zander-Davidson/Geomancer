class_name Weapon extends Node2D

@export var distance_from_parent = 200
@export var projectile_speed = 1000
@export var projectile_damage = 3
var is_selected = false
var projectile_scene

func setup(projectile_scene_in):
	projectile_scene = projectile_scene_in

func create_projectile(aim_direction: Vector2, weapon_location: Vector2):
	var projectile = projectile_scene.instantiate() as Projectile
	projectile.setup(projectile_speed, projectile_damage, aim_direction, weapon_location)
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
