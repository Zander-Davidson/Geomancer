class_name CardinalEnemy extends CharacterBody2D

var move_direction = Vector2.ZERO
@export var max_speed = 200
@export var acceleration = 5

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
		
