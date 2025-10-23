class_name CardinalEnemy extends CharacterBody2D

signal hit

@export var max_speed = 200
@export var acceleration = 5
@export var max_hp = 10

# State machine
enum State { CHASING, FIRING_CHARGE, FIRING_CHARGE_HOLD, FIRING_COOLDOWN, DYING }
var current_state

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

	# Clamp position to world bounds
	position.x = clamp(position.x, Global.WORLD_BOUNDS.position.x, Global.WORLD_BOUNDS.position.x + Global.WORLD_BOUNDS.size.x)
	position.y = clamp(position.y, Global.WORLD_BOUNDS.position.y, Global.WORLD_BOUNDS.position.y + Global.WORLD_BOUNDS.size.y)
	
# set animation to one of 8 cardinal direction animations
func process_animation():
	var move_cardinal_direction = MathUtility.get_cardinal_direction(move_direction)
	
	if max_speed > 0:
		$AnimatedSprite2D.play("moving_" +str(move_cardinal_direction))
	else:
		$AnimatedSprite2D.play("idle_" + str(move_cardinal_direction))

# projectile collision
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_projectile") and current_hp > 0.0:
		# free projectile
		area.queue_free()
		
		current_hp -= area.damage
		
		if current_hp <= 0:
			on_dying()
		
		emit_signal("hit", current_hp, max_hp)
			
func on_dying():
	current_state = State.DYING
	current_hp = 0.0
	max_speed = 0
	$DyingAnimationTimer.start()
	
func _on_dying_animation_timer_timeout() -> void:
	queue_free()
