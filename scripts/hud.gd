extends CanvasLayer
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$EnemiesKilled.text = str(Global.num_enemies_killed)

func update_game_timer():
	# calculate minutes and seconds from seconds
	var seconds_since_last_minute = Global.seconds_elapsed % 60
	var minutes_elapsed = (Global.seconds_elapsed - seconds_since_last_minute) / 60
	
	if seconds_since_last_minute < 10:
		seconds_since_last_minute = "0" + str(seconds_since_last_minute)
	
	if minutes_elapsed < 10:
		minutes_elapsed = "0" + str(minutes_elapsed)
	
	$GameTime.text = str(minutes_elapsed) + ":" + str(seconds_since_last_minute)
	
