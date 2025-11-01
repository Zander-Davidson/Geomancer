class_name Weapon 
extends Node2D

@export var distance_from_parent = 200

enum State { NOT_SELECTED, SELECTED }
var current_state = State.NOT_SELECTED

# override in child class to define weapon fired behavior
func fire_weapon_pressed(aim_direction: Vector2) -> void:
	pass
	
func fire_weapon_released():
	pass

func _process(delta: float):
	process_animation()
	
func process_animation():
	match current_state:
		State.NOT_SELECTED:
			$AnimatedSprite2D.play("not_selected")
			$AnimatedSprite2D.scale = Vector2(0.2, 0.2)
		State.SELECTED:
			$AnimatedSprite2D.play("selected")
			$AnimatedSprite2D.scale = Vector2(0.4, 0.4)
