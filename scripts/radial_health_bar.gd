extends Control

const num_distinct_sprites = 16
const full_color = Color(0.0, 1.0, 0.0, 1.0)
const empty_color = Color(1.0, 0.992, 0.128, 1.0)
const hit_pulse_scale = 1.15

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.modulate = full_color
	$AnimatedSprite2D.play("progress_" + str(num_distinct_sprites-1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_hit(current_health: float, max_health: float) -> void:
	var current_health_frac = current_health / max_health
	
	# calculate the remaining health as a number from 0 to num_distinct_sprites
	var current_sprite = ceil(current_health_frac * 15) as int
	$AnimatedSprite2D.modulate = SpriteUtility.get_gradient_color(full_color, empty_color, 1 - current_health_frac)
	$AnimatedSprite2D.play("progress_" + str(current_sprite))
	
	$AnimatedSprite2D.scale *= hit_pulse_scale
	$HitPulseTimer.start()

func _on_hit_pulse_timer_timeout() -> void:
	$AnimatedSprite2D.scale /= hit_pulse_scale
