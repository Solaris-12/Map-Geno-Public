class_name Primitive extends Node

signal attribute_changed(attribute: Attribute)
signal has_been_selected(node: Primitive, append: bool, selected: bool)

var object_name: String
var attributes: Attributes
var object_type: ObjectType.ObjectType
var node: Area3D
var label: ObjectSelectLabel

func _init(obj_name: String, attrs: Attributes, obj_tpe: ObjectType.ObjectType, nd: Area3D, label_parent = null):
	object_name = obj_name
	attributes = attrs
	object_type = obj_tpe
	node = nd

	nd.position = attrs.get_value("position")

	self.create_label(obj_name, label_parent if label_parent != null else ObjectList.SingleTon.root)

	Root.ObjectHolder.call_deferred("add_child", nd)
	nd.input_event.connect(_handle_box_selected)
	on_tool_change(Editor.current_tool)

func remove():
	if label.get_parent() != null:
		label.get_parent().remove_child(label)
	node.queue_free()
	queue_free()
	Editor.SingleTon.call_deferred("emit_signal", "tree_change", null)
	ObjectList.SingleTon.call_reload_deferred()


static func create(obj_id: int, obj_name: String, pos: Vector3, label_parent = ObjectList.SingleTon.root) -> Primitive:
	var scene = preload("res://scenes/objects/primitive.tscn")
	var scene_instance = scene.instantiate()
	var r_node = scene_instance.get_node(".")

	var attrs = Attributes.new([
		Attribute.new("id", AttributeType.AttributeType.UnEditable, obj_id),
		Attribute.new("parent_id", AttributeType.AttributeType.UnEditable, null),
		Attribute.new("position", AttributeType.AttributeType.Vector3, pos)
	])
	var instance = Primitive.new(obj_name, attrs, ObjectType.ObjectType.None, r_node, label_parent)
	attrs.attribute_changed.connect(instance._handle_attribute_change)

	return instance

static func create_default(obj_id: int, obj_name: String):
	return Primitive.create(obj_id, obj_name, Vector3(0, 0, 0))

static func from_self(obj_id: int, nd):
	return Primitive.create(obj_id, ObjectSelectLabel.object_copy_name_generator(obj_id, nd.object_name), nd.get_attribute("position"))


func create_label(obj_name: String, label_parent := ObjectList.SingleTon.root):
	self.label = ObjectList.create_object_label(obj_name, self.object_type, label_parent)
	if not label.get_tree().multi_selected.is_connected(_handle_label_selected):
		self.label.get_tree().multi_selected.connect(_handle_label_selected)

func get_base_node() -> Area3D:
	return node

func get_attribute(attr_name: String) -> Variant:
	return attributes.get_value(attr_name)

func set_attribute(attr_name: String, val: Variant):
	attributes.set_value(attr_name, val)

func get_id() -> int:
	return get_attribute("id")

func get_parent_id():
	return get_attribute("parent_id")

func set_parent(nd):
	if nd is Primitive:
		self.set_attribute("parent_id", nd.get_id())
		if self.label != null and self.label.get_parent() != null:
			self.label.get_parent().remove_child(self.label)
		self.label = self.create_label(self.object_name, nd.label)
	else:
		self.set_attribute("parent_id", null)
	Editor.SingleTon.tree_change.emit(nd)

func on_selected():
	label.handle_select(true)

func on_deselected():
	label.handle_select(false)


func on_tool_change(_t):
	match Editor.current_tool:
		ToolType.ToolType.CursorTool:
			node.input_ray_pickable = true
		ToolType.ToolType.MoveTool, ToolType.ToolType.RotateTool, ToolType.ToolType.ScaleTool:
			node.input_ray_pickable = false

func _handle_attribute_change(attr: Attribute):
	attribute_changed.emit(attr)

	if attr.name == "position":
		node.position = attr.get_value()

func _handle_label_selected(item: TreeItem, _column: int, selected: bool):
	if self.label!= null and item.get_instance_id() == self.label.get_instance_id():
		var append = Input.is_key_pressed(KEY_CTRL) or Input.is_key_pressed(KEY_SHIFT)
		has_been_selected.emit(self, append, selected)

func _handle_box_selected(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == 1:
				var append = Input.is_key_pressed(KEY_CTRL) or Input.is_key_pressed(KEY_SHIFT)
				has_been_selected.emit(self, append)
