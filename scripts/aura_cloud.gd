extends Node2D

const COLOR = Colors.SIMPLE_GREEN

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# create random alpha values
	var alpha_values = []
	
	var alpha_step = 0.05
	
	for i in range(1, 5):
		alpha_values.append(randf_range(i * alpha_step, (i+1) * alpha_step))
		
	# get layers in a random order
	var layers = get_children()
	layers.shuffle()
	
	# modulate layer colors and alpha values
	for i in range(0, 4):
		layers[i].modulate = Color(COLOR.r, COLOR.g, COLOR.b, alpha_values[i])
		layers[i].play("default")
