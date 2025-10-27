extends Control

enum State { PULSE, FADE, INVISIBLE }

const NUM_DISTINCT_SPRITES = 16

@export var full_color = Colors.SIMPLE_RED
@export var empty_color = Colors.SIMPLE_YELLOW
@export var depleted_color = Colors.SIMPLE_GREEN
@export var hit_pulse_scale = 1.15
@export var hit_pulse_wait_time = 0.05

var current_color = Colors.INVISIBLE
var current_sprite = NUM_DISTINCT_SPRITES - 1
var fade_speed = 4
var current_state = State.INVISIBLE


func _ready() -> void:
	# initialize sprite and pulse timer
	$HitPulseTimer.wait_time = hit_pulse_wait_time
	$AnimatedSprite2D.modulate = full_color
	$AnimatedSprite2D.play("progress_" + str(NUM_DISTINCT_SPRITES-1))

func _process(delta: float) -> void:
	# FADE is the only state that needs processing. other states are managed by
	# timers and state transitions
	match current_state:
		State.FADE:
			process_fade(delta)
		
	# set animation properties
	$AnimatedSprite2D.scale = clamp($AnimatedSprite2D.scale, Vector2(1,1), Vector2(1,1)*hit_pulse_scale)
	$AnimatedSprite2D.play("progress_" + str(current_sprite))
	$AnimatedSprite2D.modulate = current_color

func process_fade(delta: float):
	if current_color.a < 0.01:
		# cut off fade at threshold 
		current_color = Colors.INVISIBLE
		current_state = State.INVISIBLE
	else:
		# set current color to a value along the gradient to invisible, as a function of time
		current_color = SpriteUtility.get_gradient_color(current_color, Colors.INVISIBLE, delta * fade_speed)

func _on_hit(current_health: float, max_health: float) -> void:
	var current_health_frac = current_health / max_health
	
	if current_health_frac > 0.0:
		# calculate the remaining health as a number from 0 to NUM_DISTINCT_SPRITES
		current_sprite = ceil(current_health_frac * NUM_DISTINCT_SPRITES) as int
		
		# get current color on gradient from full to empty
		current_color = SpriteUtility.get_gradient_color(full_color, empty_color, 1 - current_health_frac)
	else:
		# on health depleted, pulse the full circle in a different color
		current_sprite = NUM_DISTINCT_SPRITES - 1
		current_color = depleted_color

	# scale the sprite for pulse effect, and start pulse timer
	$AnimatedSprite2D.scale *= hit_pulse_scale
	$HitPulseTimer.start()
	
	current_state = State.PULSE

func _on_hit_pulse_timer_timeout() -> void:
	# undo scale from pulse effect
	$AnimatedSprite2D.scale /= hit_pulse_scale
	
	current_state = State.FADE
