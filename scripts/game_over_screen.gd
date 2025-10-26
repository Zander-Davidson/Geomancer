extends CanvasLayer

func _ready() -> void:
	match Settings.get_setting("controls", "control_mode"):
		Enum.ControlMode.MOUSE_AND_KEYBOARD:
			$PressRestartLabel.text = "press space to restart"
		Enum.ControlMode.GAMEPAD:
			$PressRestartLabel.text = "press A to restart"
