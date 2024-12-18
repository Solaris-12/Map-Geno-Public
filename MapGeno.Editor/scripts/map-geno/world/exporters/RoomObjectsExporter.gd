class_name RoomObjectsExporter

const DISABLED_OBJECT_TYPES = [ObjectType.ObjectType.TemplateImage]


static func export (path: String, room_name: String, metadata: Dictionary = {}):
	var all_json = []
	for object: Primitive in Editor.created_objects:
		if object != null:
			if DISABLED_OBJECT_TYPES.has(object.object_type):
				continue

			var obj = {"type": object.object_type}
			for attr in object.attributes.attributes:
				var parsed_attr = RoomObjectsExporter.parse_attribute(attr)
				obj[parsed_attr[0]] = parsed_attr[1]

			all_json.push_front(obj)

	var json_data = {
		"name": room_name,
		"data": all_json
	}
	if !metadata.is_empty():
		json_data["metadata"] = metadata

	var json = JSON.stringify(json_data)

	var file = FileAccess.open(path, FileAccess.WRITE)
	if not file:
		var err_popup = AcceptDialog.new()
		err_popup.dialog_text = "File error: " + str(FileAccess.get_open_error())
		Root.SingleTon.add_child(err_popup)
		err_popup.popup_centered()
		print("An error happened while saving data: ", FileAccess.get_open_error())
		return

	file.store_line(json)
	file.close()

	var suc_popup = AcceptDialog.new()
	suc_popup.dialog_text = "Successfully exported!"
	suc_popup.title = "Success"
	Root.SingleTon.add_child(suc_popup)
	suc_popup.popup_centered()

static func parse_attribute(attr: Attribute) -> Array:
	# Due to the map being flipped, we need to flip it back
	if attr.name == "position":
		var pos = attr.get_value()
		return [attr.name, JsonUtils.vector3_to_dict(Vector3(pos.x, pos.y, pos.z))]

	match attr.type:
		AttributeType.AttributeType.Color:
			return [attr.name, JsonUtils.color_to_dict(attr.get_value())]
		AttributeType.AttributeType.Vector3:
			return [attr.name, JsonUtils.vector3_to_dict(attr.get_value())]
		AttributeType.AttributeType.StringOption:
			return [attr.name, attr.get_value()]
	return [attr.name, attr.get_value()]
