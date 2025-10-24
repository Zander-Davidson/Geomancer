extends CanvasLayer

var num_enemies_killed = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.enemy_killed.connect(_on_enemy_killed)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$EnemiesKilled.text = str(num_enemies_killed)
	
func _on_enemy_killed():
	num_enemies_killed += 1

func update_game_timer(seconds_elapsed):
	# calculate minutes and seconds from seconds
	var seconds_since_last_minute = seconds_elapsed % 60
	var minutes_elapsed = (seconds_elapsed - seconds_since_last_minute) / 60
	
	# TODO: add padding
	if seconds_since_last_minute < 10:
		seconds_since_last_minute = "0" + str(seconds_since_last_minute)
	
	if minutes_elapsed < 10:
		minutes_elapsed = "0" + str(minutes_elapsed)
	
	$GameTime.text = str(minutes_elapsed) + ":" + str(seconds_since_last_minute)
	
