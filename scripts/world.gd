extends Node

@export var pink_triangle_enemy_scene: PackedScene

# in seconds
var game_timer_ticks

enum State { TITLE_SCREEN, PLAYING, GAME_OVER}
var current_state

func _ready():
	ready_title_screen()
	ready_player()
	ready_world()
	
func _process(delta: float):
	match current_state:
		State.TITLE_SCREEN:
			if Input.is_action_just_pressed("start_game"):
				start_game()
			
func ready_title_screen():
	current_state = State.TITLE_SCREEN
	$TitleScreen.show()
	$HUD.hide()
		
func ready_player():
	# Position player at center of world
	if has_node("Player"):
		var player = get_node("Player")
		player.position = Vector2(Global.WORLD_WIDTH / 2, Global.WORLD_HEIGHT / 2)

		# Reset camera smoothing so it snaps to player position instead of panning
		if player.has_node("Camera2D"):
			player.get_node("Camera2D").reset_smoothing()
			
func ready_world():
	SignalBus.selected_weapon_fired.connect(_on_selected_weapon_fired)
	
func start_game():
	current_state = State.PLAYING
	$TitleScreen.hide()
	$HUD.show()
	game_timer_ticks = 0
	$EnemyTimer.start()
	$GameTimer.start()
	
func _on_selected_weapon_fired(weapon: Weapon, aim_direction: Vector2, weapon_location: Vector2):
	add_child(weapon.create_projectile(aim_direction, weapon_location))

func _on_enemy_timer_timeout() -> void:
	# Create a new instance of the enemy scene.
	var enemy = pink_triangle_enemy_scene.instantiate()

	# Choose a random location on Path2D.
	var enemy_spawn_location = $EnemyPath/EnemySpawnLocation
	enemy_spawn_location.progress_ratio = randf()

	# Set the enemy's position to the random location.
	# Use global_position since enemy is added to World, not EnemyPath
	enemy.position = enemy_spawn_location.global_position
	
	# Spawn the enemy by adding it to the Main scene.
	add_child(enemy)

func _on_game_timer_timeout() -> void:
	game_timer_ticks += 1
	$HUD.update_game_timer(game_timer_ticks)
