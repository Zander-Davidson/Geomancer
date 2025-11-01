extends Node


func _ready():
	Global.player = preload("res://scenes/player/player.tscn").instantiate()
	add_child(Global.player)
	
	ready_title_screen()
	ready_player()
	ready_signals()
	
func _process(delta: float):
	match Global.game_state:
		Enum.GameState.TITLE_SCREEN:
			if Input.is_action_just_pressed("start_game"):
				game_start()
		Enum.GameState.GAME_OVER_SCREEN:
				if Input.is_action_just_pressed("start_game"):
					reset_game()
			
func ready_title_screen():
	Global.game_state = Enum.GameState.TITLE_SCREEN
	$UI/TitleScreen.show()
	$UI/HUD.hide()
		
func ready_player():
	Global.player.setup()
			
func ready_signals():
	SignalBus.selected_projectile_weapon_fired.connect(_on_selected_projectile_weapon_fired)
	SignalBus.player_death.connect(_on_player_death)
	
func game_start():
	Global.game_state = Enum.GameState.PLAYING
	
	$UI/TitleScreen.hide()
	$UI/HUD.show()
	
	$UI/HUD/GameTime.text = "00:00"
	Global.seconds_elapsed = 0
	Global.num_enemies_killed = 0
	
	$EnemyTimer.start()
	$GameTimer.start()
	
func _on_player_death():
	Global.game_state = Enum.GameState.PLAYER_DEATH
	
	$EnemyTimer.stop()
	$GameTimer.stop()
	
	# wait for player death animation to finish
	$GameOverWaitTimer.start()
	
func reset_game():
	$UI/GameOverScreen.hide()
	
	# clear enemies
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.queue_free()
		
	# clear projectiles
	for projectile in get_tree().get_nodes_in_group("projectile"):
		projectile.queue_free()
			
	ready_title_screen()
	ready_player()
	
func _on_selected_projectile_weapon_fired(weapon: ProjectileWeapon, aim_direction: Vector2):
	add_child(weapon.create_projectile(aim_direction))

func _on_enemy_timer_timeout() -> void:
	var enemy = EnemyFactory.create_random_enemy()
	
	# TODO: broken
	# Choose a random location on Path2D.
	var enemy_spawn_location = $EnemyPath/EnemySpawnLocation
	enemy_spawn_location.progress_ratio = randf()
	
	# Set the enemy's position to the random location.
	# Use global_position since enemy is added to World, not EnemyPath
	enemy.position = enemy_spawn_location.global_position
	
	# Spawn the enemy by adding it to the Main scene.
	add_child(enemy)

func _on_game_timer_timeout() -> void:
	# add 1 second to game timer
	Global.seconds_elapsed += 1

	# update HUD
	$UI/HUD.update_game_timer()

func _on_game_over_scene_timer_timeout() -> void:
	Global.game_state = Enum.GameState.GAME_OVER_SCREEN
	Global.player.hide()
	$UI/GameOverScreen.show()
