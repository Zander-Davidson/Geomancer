extends Node

# Signal emitted when a setting changes
signal setting_changed(category: String, key: String, value)

# Path to settings file in user directory
const SETTINGS_FILE_PATH = "user://settings.cfg"

# ConfigFile object to manage settings
var config = ConfigFile.new()

# Default settings
var defaults = {
	"audio": {
		"master_volume": 1.0,
		"music_volume": 0.8,
		"sfx_volume": 1.0,
		"muted": false
	},
	"display": {
		"fullscreen": false,
		"vsync": true,
		"resolution_width": 1440,
		"resolution_height": 960
	},
	"gameplay": {
		"difficulty": 1,
		"auto_save": true,
		"screen_shake": true
	},
	"controls": {
		"control_mode": Enum.ControlMode.GAMEPAD,
		"controller_sensitivity": 1.0,
		"controller_vibration": true
	}
}

func _ready():
	load_settings()

# Load settings from disk or create with defaults
func load_settings():
	print(OS.get_data_dir())
	var error = config.load(SETTINGS_FILE_PATH)

	if error != OK:
		print("Settings file not found, creating with defaults...")
		reset_to_defaults()
		save_settings()
	else:
		print("Settings loaded successfully from: ", SETTINGS_FILE_PATH)

	# Apply display settings
	apply_display_settings()

# Save settings to disk
func save_settings():
	var error = config.save(SETTINGS_FILE_PATH)
	if error != OK:
		push_error("Failed to save settings to: " + SETTINGS_FILE_PATH)
	else:
		print("Settings saved successfully")

# Get a setting value with optional default
func get_setting(category: String, key: String, default = null):
	if config.has_section_key(category, key):
		return config.get_value(category, key)
	elif defaults.has(category) and defaults[category].has(key):
		return defaults[category][key]
	else:
		return default

# Set a setting value and save
func set_setting(category: String, key: String, value):
	config.set_value(category, key, value)
	save_settings()
	setting_changed.emit(category, key, value)

# Reset all settings to defaults
func reset_to_defaults():
	config.clear()
	for category in defaults:
		for key in defaults[category]:
			config.set_value(category, key, defaults[category][key])
	print("Settings reset to defaults")

# Apply display settings to the window
func apply_display_settings():
	var fullscreen = get_setting("display", "fullscreen", false)
	var vsync = get_setting("display", "vsync", true)

	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	if vsync:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

# Convenience methods for audio settings
func get_master_volume() -> float:
	return get_setting("audio", "master_volume", 1.0)

func set_master_volume(volume: float):
	set_setting("audio", "master_volume", clamp(volume, 0.0, 1.0))

func get_music_volume() -> float:
	return get_setting("audio", "music_volume", 0.8)

func set_music_volume(volume: float):
	set_setting("audio", "music_volume", clamp(volume, 0.0, 1.0))

func get_sfx_volume() -> float:
	return get_setting("audio", "sfx_volume", 1.0)

func set_sfx_volume(volume: float):
	set_setting("audio", "sfx_volume", clamp(volume, 0.0, 1.0))

func is_muted() -> bool:
	return get_setting("audio", "muted", false)

func set_muted(muted: bool):
	set_setting("audio", "muted", muted)

# Convenience methods for display settings
func is_fullscreen() -> bool:
	return get_setting("display", "fullscreen", false)

func set_fullscreen(fullscreen: bool):
	set_setting("display", "fullscreen", fullscreen)
	apply_display_settings()

func is_vsync_enabled() -> bool:
	return get_setting("display", "vsync", true)

func set_vsync(enabled: bool):
	set_setting("display", "vsync", enabled)
	apply_display_settings()

# Convenience methods for gameplay settings
func get_difficulty() -> int:
	return get_setting("gameplay", "difficulty", 1)

func set_difficulty(difficulty: int):
	set_setting("gameplay", "difficulty", difficulty)

func is_auto_save_enabled() -> bool:
	return get_setting("gameplay", "auto_save", true)

func set_auto_save(enabled: bool):
	set_setting("gameplay", "auto_save", enabled)

func is_screen_shake_enabled() -> bool:
	return get_setting("gameplay", "screen_shake", true)

func set_screen_shake(enabled: bool):
	set_setting("gameplay", "screen_shake", enabled)

# Convenience methods for control settings
func get_controller_sensitivity() -> float:
	return get_setting("controls", "controller_sensitivity", 1.0)

func set_controller_sensitivity(sensitivity: float):
	set_setting("controls", "controller_sensitivity", clamp(sensitivity, 0.1, 2.0))

func is_controller_vibration_enabled() -> bool:
	return get_setting("controls", "controller_vibration", true)

func set_controller_vibration(enabled: bool):
	set_setting("controls", "controller_vibration", enabled)
