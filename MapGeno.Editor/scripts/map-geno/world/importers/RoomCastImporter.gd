class_name RoomCastImporter

static var thread_prepare: Thread
static var thread_process: Thread

static func import(path: String):
	thread_prepare = Thread.new()
	thread_prepare.start(RoomCastImporter.import_prepare.bind(path))

static func import_prepare(path: String):
	LoadingWrapper.SingleTon.call_deferred("update_loading", 0, 3, "RAYCAST IMPORT\nReading file:\n")
	var json_as_text = FileAccess.get_file_as_string(path)
	if not json_as_text:
		var err_popup = AcceptDialog.new()
		err_popup.dialog_text = "File error: " + str(FileAccess.get_open_error())
		Root.SingleTon.add_child(err_popup)
		err_popup.popup_centered()
		return

	LoadingWrapper.SingleTon.call_deferred("update_loading", 1, 3, "RAYCAST IMPORT\nParsing file:\n")
	var json_as_dict = JSON.parse_string(json_as_text)
	if json_as_dict:
		if not json_as_dict.has("points"): # Check if the file is in the corect format
			var err_popup = AcceptDialog.new()
			err_popup.dialog_text = "Invalid file format, couldn't find 'points' in json!"
			Root.SingleTon.add_child(err_popup)
			err_popup.popup_centered()
			return
		thread_process = Thread.new()
		LoadingWrapper.SingleTon.call_deferred("update_loading", 2, 3, "RAYCAST IMPORT\nStarting import:\n")
		thread_process.start(RoomCastImporter.import_process.bind(json_as_dict))
	else:
		LoadingWrapper.SingleTon.call_deferred("update_loading", 0, 0)

static func import_process(json: Dictionary):
	var data = json["points"]
	var accuracy = 0.41
	if json.has("accuracy") and json["accuracy"] > 0:
		accuracy = json["accuracy"]

	var amount_of_points = min(len(data), Settings.max_raycast_hits)
	var maxtuare = 1

	if (amount_of_points / accuracy) > 2000000:
		maxtuare = 10
	elif (amount_of_points / accuracy) > 600000:
		maxtuare = 5
	elif (amount_of_points / accuracy) > 300000:
		maxtuare = 2

	var loading_message = "RAYCAST IMPORT\nImporting:\n"
	if maxtuare > 1:
		loading_message = "RAYCAST IMPORT\nImporting every " + str(maxtuare) + "(th):\n"

	for index in amount_of_points:
		if index % maxtuare != 0:
			continue

		var point = data[index]
		var pos = JsonUtils.vector3_from_dict(point["position"])

		var color = RoomCastImporter.string_to_color(point["name"])
		var mesh_instance = MeshInstance3D.new()
		var mesh = BoxMesh.new()
		var material = StandardMaterial3D.new()
		material.albedo_color = color
		material.emission_enabled = false
		material.rim_enabled = false
		mesh.size = Vector3(0.1, 0.1, 0.1)
		mesh.material = material
		mesh_instance.mesh = mesh
		mesh_instance.position = Vector3(pos.x, pos.y, pos.z)
		mesh_instance.visibility_range_end = Settings.background_distance

		Root.WorldHolder.call_deferred("add_child", mesh_instance)
		if index % 300 == 0:
			LoadingWrapper.SingleTon.call_deferred("update_loading", index, amount_of_points, loading_message)
	LoadingWrapper.SingleTon.call_deferred("update_loading", 0, 0, "Finished")

static func string_to_color(text: String) -> Color:
		var hsh = 0
		for i in range(text.length()):
				hsh = (hsh * 21 + text[i].unicode_at(0)) % 0xFFFFFF
		var color = Color(float(hsh & 0xFF) / 256, float((hsh >> 8) & 0xFF) / 256, float((hsh >> 16) & 0xFF) / 256)

		return color
