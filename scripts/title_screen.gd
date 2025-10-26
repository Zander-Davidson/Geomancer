extends CanvasLayer

func _ready() -> void:
	match Settings.get_setting("controls", "control_mode"):
		Enum.ControlMode.MOUSE_AND_KEYBOARD:
			$PressStartLabel.text = "press space to start"
		Enum.ControlMode.GAMEPAD:
			$PressStartLabel.text = "press A to start"
