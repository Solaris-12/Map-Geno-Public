extends CanvasLayer

@onready var v_sync_checkbox: CheckButton = $SettingsPanel/VBoxContainer/TabContainer/Render/VBoxContainer/VSyncCheckbox
@onready var max_framerate_input: LineEdit = $SettingsPanel/VBoxContainer/TabContainer/Render/VBoxContainer/HBoxContainer/MaxFramerateInput
@onready var anti_alliasing_checkbox: CheckButton = $SettingsPanel/VBoxContainer/TabContainer/Render/VBoxContainer/AntiAlliasingCheckbox

@onready var background_distance_input: LineEdit = $SettingsPanel/VBoxContainer/TabContainer/World/VBoxContainer/HBoxContainer/BackgroundDistanceInput
@onready var max_raycast_hits_input: LineEdit = $SettingsPanel/VBoxContainer/TabContainer/World/VBoxContainer/HBoxContainer2/MaxRaycastHitsInput

@onready var version_label = $SettingsPanel/VBoxContainer/TabContainer/MapGeno/CenterContainer/VBoxContainer/VERSION

var background_distance: float = 24
var max_raycast_hits: int = 3_500_000

var vsync_enabled: bool = true
var max_framerate: int = 60
var anti_aliasing: bool = false

func _ready():
	ProjectSettings.settings_changed.connect(_reload_settings)
	_reload_settings()

func _reload_settings():
	background_distance = Settings.background_distance
	max_raycast_hits = Settings.max_raycast_hits
	vsync_enabled = Settings.vsync_enabled
	max_framerate = Settings.max_framerate
	anti_aliasing = Settings.anti_aliasing
	
	v_sync_checkbox.button_pressed = vsync_enabled
	max_framerate_input.text = str(max_framerate)
	anti_alliasing_checkbox.button_pressed = anti_aliasing
	background_distance_input.text = str(background_distance)
	max_raycast_hits_input.text = str(max_raycast_hits)
	
	version_label.text = "v" + ProjectSettings.get_setting("application/config/version", "NOT FOUND")


func _on_v_sync_checkbox_toggled(toggled_on):
	vsync_enabled = toggled_on

func _on_anti_alliasing_checkbox_toggled(toggled_on):
	anti_aliasing = toggled_on

func _on_max_framerate_input_text_changed(_t):
	max_framerate = InputUtils.parse_int(max_framerate_input)

func _on_background_distance_input_text_changed(_t):
	background_distance = InputUtils.parse_float(background_distance_input)

func _on_max_raycast_hits_input_text_changed(_t):
	max_raycast_hits = InputUtils.parse_int(max_raycast_hits_input)


func _on_apply_button_pressed():
	Settings.background_distance = background_distance
	Settings.max_raycast_hits = max_raycast_hits
	Settings.vsync_enabled = vsync_enabled
	Settings.max_framerate = max_framerate
	Settings.anti_aliasing = anti_aliasing
	Settings.save_settings()
	Settings.setup_settings(false)


func _on_close_button_pressed():
	self.hide()
