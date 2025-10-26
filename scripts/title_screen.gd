extends CanvasLayer

func _ready() -> void:
	match Settings.get_setting("controls", "control_mode"):
		Enum.ControlMode.MOUSE_AND_KEYBOARD:
			$PressStartLabel.text = "press space to start"
			$MoveAndAimLabel.text = "WASD - move"
			$ShootAndSwitchLabel.text = "left click - fire weapon\nright click - switch weapon"
			
		Enum.ControlMode.GAMEPAD:
			$PressStartLabel.text = "press A to start"
			$MoveAndAimLabel.text = "left stick - move\nright stick - aim"
			$ShootAndSwitchLabel.text = "right trigger - fire weapon\nleft trigger - switch weapon"
			
