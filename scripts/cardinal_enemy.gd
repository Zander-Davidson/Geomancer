class_name CardinalEnemy extends CharacterBody2D

signal hit

@export var max_speed = 200
@export var acceleration = 5
@export var max_hp = 10

var move_direction = Vector2.ZERO
var current_hp = max_hp

func setup(initial_position):
	position = initial_position

func _process(delta: float):
	if Global.player != null:
		process_input()
		process_movement(delta)
		process_animation()
	
func process_input():
	move_direction = (Global.player.position - position).normalized()
	
func process_movement(delta: float):
	velocity = velocity.lerp(move_direction * max_speed, acceleration * delta)
	move_and_slide()
	
# set animation to one of 8 cardinal direction animations
func process_animation():
	var move_cardinal_direction = MathUtility.get_cardinal_direction(move_direction)
	
	if max_speed > 0:
		$AnimatedSprite2D.play("moving_" +str(move_cardinal_direction))
	else:
		$AnimatedSprite2D.play("idle_" + str(move_cardinal_direction))
		
#func _on_area_2d_body_entered(body: Node2D) -> void:
	#print("enemy body entered")
#
	#if body.is_in_group("player_projectile"):
		#print("projectile hit enemy")
		#current_hp -= body.damage
		#emit_signal("hit", current_hp, max_hp)

func _on_area_2d_area_entered(area: Area2D) -> void:
	print("enemy area entered")

	if area.is_in_group("player_projectile"):
		print("projectile hit enemy")
		current_hp -= area.damage
		emit_signal("hit", current_hp, max_hp)
