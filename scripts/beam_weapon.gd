class_name BeamWeapon
extends Weapon

enum SubState { FIRING, READY }
var current_sub_state = SubState.READY

var beam: Line2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	
	match current_sub_state:
		SubState.FIRING:
			print("firing")
			# draw beam
			
		SubState.READY:
			print("ready")
			pass
			
			
func fire_weapon_pressed(aim_direction: Vector2) -> void:
	
	#if current_sub_state == SubState.READY:
		#
	#elif current_sub_state == SubState.FIRING:
		#
	
	current_sub_state = SubState.FIRING
	
	beam = Line2D.new()
	beam.add_point(position)
	beam.add_point(aim_direction * 1000)
	beam.modulate = Color.BLUE_VIOLET
	add_child(beam)
	
	beam.queue_free()
	
	# create new beam
	# TODO: this is probably (definitely) super inefficient
	beam = Line2D.new()
	


func fire_weapon_released():
	current_sub_state = SubState.READY
	
	#beam.queue_free()
	
