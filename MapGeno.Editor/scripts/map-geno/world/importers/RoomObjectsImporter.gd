class_name RoomObjectsImporter

static var thread_prepare: Thread
static var thread_process: Thread

static func import(path: String):

	LoadingWrapper.SingleTon.call_deferred("update_loading", 0, 3, "OBJECTS IMPORT\nReading file:\n")
	var json_as_text = FileAccess.get_file_as_string(path)
	if not json_as_text:
		var err_popup = AcceptDialog.new()
		err_popup.dialog_text = "File error: " + str(FileAccess.get_open_error())
		Root.SingleTon.add_child(err_popup)
		err_popup.popup_centered()
		return

	LoadingWrapper.SingleTon.call_deferred("update_loading", 1, 3, "OBJECTS IMPORT\nParsing file:\n")
	var json_as_dict = JSON.parse_string(json_as_text)
	if json_as_dict:
		if not json_as_dict.has("data"):  # Check if the file is in the corect format
			var err_popup = AcceptDialog.new()
			err_popup.dialog_text = "Invalid file format, couldn't find 'data' in json!"
			Root.SingleTon.add_child(err_popup)
			err_popup.popup_centered()
			return

		print("Import started")
		ObjectList.reload_disabled = true
		LoadingWrapper.SingleTon.call_deferred("update_loading", 2, 3, "OBJECTS IMPORT\nStarting import:\n")
		var loading_message = "OBJECTS IMPORT\nImporting:\n"

		var imported_objects = [] as Array[Primitive]
		var amount_of_data = len(json_as_dict["data"])

		print("Loading data")
		for index in amount_of_data:
			var object = json_as_dict["data"][index]
			var obj = ObjectType.from_int(object["type"])
			var obj_id = object["id"] if int(object.has("id")) else Editor.NewObjectId
			var obj_name = ObjectType.translate(obj) + " " + str(index);
			var obj_pos = JsonUtils.vector3_from_dict(object["position"])
			var node: Primitive
			match obj:
				ObjectType.ObjectType.None:
					node = Primitive.create(obj_id, obj_name, obj_pos)
				ObjectType.ObjectType.Cube, ObjectType.ObjectType.Sphere, ObjectType.ObjectType.Capsule, ObjectType.ObjectType.Cylinder, ObjectType.ObjectType.Plane:
					var obj_rot = JsonUtils.vector3_from_dict(object["rotation"])
					var obj_scl = JsonUtils.vector3_from_dict(object["scale"])
					var obj_clr = JsonUtils.color_from_dict(object["color"])
					node = PrimitiveObject.create_object(obj_id, obj_name, obj, obj_pos, obj_rot, obj_scl, obj_clr)
				ObjectType.ObjectType.Light:
					var obj_clr = JsonUtils.color_from_dict(object["color"])
					node = PrimitiveLight.create_light(obj_id, obj_name, obj_pos, obj_clr, object["light_intensity"], object["light_range"], object["light_shadows"])
				ObjectType.ObjectType.Prefab:
					var obj_rot = JsonUtils.vector3_from_dict(object["rotation"])
					var obj_scl = JsonUtils.vector3_from_dict(object["scale"])
					node = PrimitivePrefab.create_prefab(obj_id, obj_name, obj, obj_pos, obj_rot, obj_scl, object["prefab_type"])
				ObjectType.ObjectType.ItemSpawn:
					var obj_rot = JsonUtils.vector3_from_dict(object["rotation"])
					var obj_scl = JsonUtils.vector3_from_dict(object["scale"])
					node = PrimitiveItemSpawn.create_item_spawn(obj_id, obj_name, obj, obj_pos, obj_rot, obj_scl, object["item_type"])
				ObjectType.ObjectType.SpawnPoint:
					var obj_rot = JsonUtils.vector3_from_dict(object["rotation"])
					node = PrimitiveSpawnpoint.create_spawn_point(obj_id, obj_name, obj, obj_pos, obj_rot, object["role_type"])
				ObjectType.ObjectType.Door:
					var obj_rot = JsonUtils.vector3_from_dict(object["rotation"])
					var obj_scl = JsonUtils.vector3_from_dict(object["scale"])
					node = PrimitiveDoor.create_door(obj_id, obj_name, obj, obj_pos, obj_rot, obj_scl, object["door_type"], object["lock_type"], object["permissions"], object["is_open"], object["allow_106"])
				ObjectType.ObjectType.Group:
					node = PrimitiveGroup.create_group(obj_id, object["name"], obj_pos)

			Root.ObjectHolder.add_child(node)
			node.set_attribute("parent_id", object["parent_id"] if object.has("parent_id") else null)
			Editor.add_created_object(node)
			Editor.SingleTon.tool_change.connect(node.on_tool_change)
			node.has_been_selected.connect(Editor.select_one_object)
			node.attribute_changed.connect(Editor.SingleTon._handle_attribute_change.bind(node))
			
			imported_objects.push_front(node)

			LoadingWrapper.SingleTon.call_deferred("update_loading", index, amount_of_data, loading_message)
			
		var root_instance = PrimitiveGroup.create_default(Editor.NewObjectId, "Imported group")
		Root.ObjectHolder.add_child(root_instance)
		Editor.add_created_object(root_instance)
		root_instance.has_been_selected.connect(Editor.select_one_object)
		root_instance.attribute_changed.connect(Editor.SingleTon._handle_attribute_change.bind(root_instance))
		Editor.SingleTon.tool_change.connect(root_instance.on_tool_change)
		
		for obj in imported_objects:
			if obj.get_parent_id() == null:
				obj.set_parent(root_instance)


	print("Import finished")
	ObjectList.SingleTon.set_deferred("reload_disabled", false)
	ObjectList.SingleTon.call_deferred("call_reload_deferred")
	LoadingWrapper.SingleTon.call_deferred("update_loading", 0, 0, "Finished")

