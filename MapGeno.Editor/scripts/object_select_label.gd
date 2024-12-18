class_name ObjectSelectLabel extends TreeItem

static func object_copy_name_generator(obj_id: int, object_name: String) -> String:
	if object_name.contains(" Copy"):
		var normal = object_name.split(" Copy", true, 2)
		return normal[0] + " Copy-" + str(obj_id)
	else:
		return object_name + " Copy-" + str(obj_id)

func set_object_name(object_name: String):
	self.set_text(1, object_name)

func handle_select(is_item_selected: bool):
	if self.get_tree() != null:
		self.get_tree().call_deferred("release_focus")

	if is_item_selected:
		self.set_custom_color(0, Color.from_string("#97EB79", Color.PALE_GREEN))
	else:
		if not self.is_queued_for_deletion():
			self.call_deferred("set_custom_color", 0, Color.WHITE_SMOKE)
