extends Control

const num_distinct_sprites = 16

@export var full_color = Colors.SIMPLE_RED
@export var empty_color = Colors.SIMPLE_YELLOW
@export var depleted_color = Colors.SIMPLE_GREEN
var current_color = Colors.INVISIBLE
var current_sprite = num_distinct_sprites - 1
var fade_speed = 4

@export var hit_pulse_scale = 1.15
@export var hit_pulse_wait_time = 0.05

enum State { PULSE, FADE, INVISIBLE }
var current_state = State.INVISIBLE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HitPulseTimer.wait_time = hit_pulse_wait_time
	$AnimatedSprite2D.modulate = full_color
	$AnimatedSprite2D.play("progress_" + str(num_distinct_sprites-1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match current_state:
		State.FADE:
			process_fade(delta)
		
	$AnimatedSprite2D.scale = clamp($AnimatedSprite2D.scale, Vector2(1,1), Vector2(1,1)*hit_pulse_scale)
	$AnimatedSprite2D.play("progress_" + str(current_sprite))
	$AnimatedSprite2D.modulate = current_color

func process_fade(delta: float):
	if current_color.a < 0.01:
		current_state = State.INVISIBLE
		current_color = Colors.INVISIBLE
	else:
		current_color = SpriteUtility.get_gradient_color(current_color, Colors.INVISIBLE, delta * fade_speed)

func _on_hit(current_health: float, max_health: float) -> void:
	current_state = State.PULSE
	var current_health_frac = current_health / max_health
	
	if current_health_frac > 0.0:
		# calculate the remaining health as a number from 0 to num_distinct_sprites
		current_sprite = ceil(current_health_frac * num_distinct_sprites) as int
		
		# get current color on gradient from full to empty
		current_color = SpriteUtility.get_gradient_color(full_color, empty_color, 1 - current_health_frac)
	else:
		# dying double pulse
		current_sprite = num_distinct_sprites - 1
		current_color = depleted_color

	# scale the sprite for pulse effect
	$AnimatedSprite2D.scale *= hit_pulse_scale
	$HitPulseTimer.start()

func _on_hit_pulse_timer_timeout() -> void:
	current_state = State.FADE
	
	# undo scale from pulse effect
	$AnimatedSprite2D.scale /= hit_pulse_scale
