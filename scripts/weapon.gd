class_name Weapon extends Node2D

@export var distance_from_parent = 50
var is_selected = false
var projectile_scene

func setup(projectile_scene_in):
	projectile_scene = projectile_scene_in

func _process(delta: float):
	process_animation()
	
func process_animation():
	if is_selected:
		$AnimatedSprite2D.play("selected")
		$AnimatedSprite2D.scale = Vector2(0.4, 0.4)
	else:
		$AnimatedSprite2D.play("not_selected")
		$AnimatedSprite2D.scale = Vector2(0.2, 0.2)
