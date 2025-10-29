extends Node

const ENEMY_PACKED_SCENE = preload("res://scenes/enemies/pink_triangle_enemy.tscn")

# other name ideas: wimpy
const ENEMY_CONFIG = {
	"puny": {
		"color": Color(0.854, 0.76, 0.409, 1.0),
		"max_hp_modifier": 1.0,
		"speed_modifier": 1.0,
		"projectile_damage_modifier": 1
	},
	"baby": 
	{
		"color": Color(0.616, 0.746, 0.952, 1.0),
		"max_hp_modifier": 5.0,
		"speed_modifier": 1.0,
		"projectile_damage_modifier": 1
	},
	"squishy": 
	{
		"color": Color(0.942, 0.74, 0.94, 1.0),
		"max_hp_modifier": 10.0,
		"speed_modifier": 1.0,
		"projectile_damage_modifier": 1
	},
	"spongey": 
	{
		"color": Color(0.128, 0.878, 0.746, 1.0),
		"max_hp_modifier": 15.0,
		"speed_modifier": 1.0,
		"projectile_damage_modifier": 1
	},
	"hearty": 
	{
		"color": Color(0.0, 0.255, 1.0, 1.0),
		"max_hp_modifier": 25.0,
		"speed_modifier": 2.0,
		"projectile_damage_modifier": 2.0
	},
	"pointy": 
	{
		"color": Color(0.494, 0.843, 0.09, 1.0),
		"max_hp_modifier": 15.0,
		"speed_modifier": 2.5,
		"projectile_damage_modifier": 2.5
	},
	"scary": 
	{
		"color": Color(0.934, 0.091, 0.443, 1.0),
		"max_hp_modifier": 10.0,
		"speed_modifier": 3.0,
		"projectile_damage_modifier": 3
	},
}

func create_random_enemy() -> CardinalEnemy:
	var enemy = ENEMY_PACKED_SCENE.instantiate() as CardinalEnemy
	
	var random_enemy = ENEMY_CONFIG.keys().pick_random()
	
	enemy.setup(
		ENEMY_CONFIG[random_enemy]["color"],
		ENEMY_CONFIG[random_enemy]["max_hp_modifier"],
		ENEMY_CONFIG[random_enemy]["speed_modifier"],
		ENEMY_CONFIG[random_enemy]["projectile_damage_modifier"]
	)
	
	return enemy
	
	
