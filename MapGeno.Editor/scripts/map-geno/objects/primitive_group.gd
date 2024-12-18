class_name PrimitiveGroup extends Primitive
var _editing := false

func _init(obj_name: String, attrs: Attributes, nd: Area3D, label_parent = ObjectList.SingleTon.root):
	super(obj_name, attrs, ObjectType.ObjectType.Group, nd, label_parent)

static func create_group(obj_id: int, obj_name: String, pos: Vector3, label_parent = ObjectList.SingleTon.root) -> PrimitiveGroup:
	var r_node = Area3D.new()

	var attrs = Attributes.new([
		Attribute.new("id", AttributeType.AttributeType.UnEditable, obj_id),
		Attribute.new("parent_id", AttributeType.AttributeType.UnEditable, null),
		Attribute.new("name", AttributeType.AttributeType.String, obj_name),
		Attribute.new("position", AttributeType.AttributeType.Vector3, pos),
		Attribute.new("rotation", AttributeType.AttributeType.Vector3, Vector3(0, 0, 0)),
	])
	var instance = PrimitiveGroup.new(obj_name, attrs, r_node, label_parent)
	attrs.attribute_changed.connect(instance._handle_attribute_change)

	return instance

static func create_default(obj_id: int, obj_name: String) -> PrimitiveGroup:
	return PrimitiveGroup.create_group(obj_id, obj_name, Vector3.ZERO)

static func from_self(obj_id: int, nd: PrimitiveGroup) -> PrimitiveGroup:
	return PrimitiveGroup.create_group(obj_id, ObjectSelectLabel.object_copy_name_generator(obj_id, nd.object_name), nd.get_attribute("position"))

func create_label(obj_name: String, label_parent := ObjectList.SingleTon.root):
	super.create_label(obj_name, label_parent)
	self.label.add_button(0, preload("res://assets/icons/edit-icon.png"), 3, false, "Edit Group")
	if not label.get_tree().button_clicked.is_connected(_handle_button_click):
		self.label.get_tree().button_clicked.connect(_handle_button_click)


func on_selected():
	if _editing:
		label.handle_select(true)
		_editing = false
		return
	var childs = ObjectList.find_objs_by_parent(self.get_id())
	Editor.select_multiple_objects(childs)

func get_attribute(attr_name: String) -> Variant:
	match attr_name:
		"position", "rotation":
			return Vector3(0, 0, 0)
	return attributes.get_value(attr_name)

func _handle_attribute_change(attr: Attribute):
	match attr.name:
		"name":
			object_name = attr.value
			label.set_object_name(attr.value)
		"position":
			if attr.value == Vector3.ZERO:
				return
			var childs = ObjectList.find_objs_by_parent(self.get_id())
			for child in childs:
				var pos = child.get_attribute("position")
				if pos != null:
					child.set_attribute("position", pos + attr.value)
			self.set_attribute("position", Vector3.ZERO)
			attribute_changed.emit(Attribute.new("position", AttributeType.AttributeType.Vector3, Vector3.ZERO))
			return
		"rotation":
			if attr.value == Vector3.ZERO:
				return
			var childs = ObjectList.find_objs_by_parent(self.get_id())
			var sum_position = Vector3()
			for child in childs:
				var pos = child.get_attribute("position")
				if pos:
					sum_position += pos
			var average_position = sum_position / childs.size()

			for child in childs:
				var pos = child.get_attribute("position")
				var rot = child.get_attribute("rotation")
				if pos != null:
					var motion = ObjectEditCursor.rotate_vector_around_point(pos, average_position, attr.value.x, Vector3.RIGHT)
					motion = ObjectEditCursor.rotate_vector_around_point(motion, average_position, attr.value.y, Vector3.UP)
					motion = ObjectEditCursor.rotate_vector_around_point(motion, average_position, attr.value.z, Vector3.BACK)

					child.set_attribute("position", motion)
				if rot != null:
					child.set_attribute("rotation", rot + attr.value)
			self.set_attribute("rotation", Vector3.ZERO)
			self.set_attribute("position", Vector3.ZERO)
			attribute_changed.emit(Attribute.new("rotation", AttributeType.AttributeType.Vector3, Vector3.ZERO))
			attribute_changed.emit(Attribute.new("position", AttributeType.AttributeType.Vector3, Vector3.ZERO))
			return
	attribute_changed.emit(attr)

func _handle_light_instance_process(pos):
	if node.position != pos:
		node.look_at(pos)

func _handle_button_click(item: TreeItem, _col, id: int, _mouse_button):
	if item.get_instance_id() == self.label.get_instance_id():
		if id == 3:
			_editing = true
			Editor.select_one_object(self)

