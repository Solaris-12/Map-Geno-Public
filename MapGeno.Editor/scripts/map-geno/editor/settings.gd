class_name Settings extends Object

static var settings_path = "user://settings.json"

static var background_distance: float = 24
static var max_raycast_hits: int = 3_500_000

static var vsync_enabled: bool = true
static var max_framerate: int = 60
static var anti_aliasing: bool = false

static func setup_settings(also_load_settings := true):
	if also_load_settings:
		Settings.load_settings()

	ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_3d", 5 if Settings.anti_aliasing else 0)
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_2d", 3 if Settings.anti_aliasing else 0)
	Engine.max_fps = Settings.max_framerate;
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if Settings.vsync_enabled else DisplayServer.VSYNC_DISABLED)
	
	if Root.WorldHolder != null:
		for obj: MeshInstance3D in Root.WorldHolder.get_children():
			if obj == null: continue
			obj.visibility_range_end = Settings.background_distance


static func load_settings():
	var file = FileAccess.open(settings_path, FileAccess.READ)
	if not file:
		var err = FileAccess.get_open_error()
		if err != ERR_FILE_NOT_FOUND:
			printerr("An error happened while reading settings: ", err)
		return

	var data = file.get_line()
	if not data:
		printerr("Couldn't read data from settings file: ", FileAccess.get_open_error())
		return

	var data_as_dict = JSON.parse_string(data)
	if not data_as_dict:
		printerr("Failed to parse settings json")
		return

	print_rich("Loading settings: ", data_as_dict)

	background_distance = data_as_dict["background_distance"]
	max_raycast_hits = data_as_dict["max_raycast_hits"]
	vsync_enabled = data_as_dict["vsync_enabled"]
	max_framerate = data_as_dict["max_framerate"]
	anti_aliasing = data_as_dict["anti_aliasing"]

	file.close()

static func save_settings():
	var data_as_dict = {
		"background_distance" = background_distance,
		"max_raycast_hits" = max_raycast_hits,
		"vsync_enabled" = vsync_enabled,
		"max_framerate" = max_framerate,
		"anti_aliasing" = anti_aliasing
	}
	print_rich("Savomg settings: ", data_as_dict)

	var data = JSON.stringify(data_as_dict)
	var file = FileAccess.open(settings_path, FileAccess.WRITE)
	if not file:
		var err = FileAccess.get_open_error()
		printerr("An error happened while reading settings: ", err)
		return

	file.store_line(data)
	file.close()


