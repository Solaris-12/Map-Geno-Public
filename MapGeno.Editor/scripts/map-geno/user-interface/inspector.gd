class_name Inspector extends Node

static var SingleTon: Inspector
static var InputsList: Array[InspectorInputBase]

@onready var inspector_content_layout = $InspectorPanel/TabContainer/Inspector/InspectorContentLayout

func _ready():
	SingleTon = self
	call_deferred("_update_world_stats")


static func reload_attribute_list():
	while InputsList.size() > 0:
		var input = InputsList.pop_back()
		input.queue_free()

	if Editor.selected_nodes.size() == 1:
		var node = Editor.selected_nodes[0]

		for attr: Attribute in node.attributes.attributes:
			var input_scene = SingleTon._input_scene_from_attr_type(attr.type)
			var input = input_scene.instantiate()
			SingleTon.inspector_content_layout.add_child(input)
			input.set_label(attr.name)
			input.set_val(attr.value)
			input.update.connect(SingleTon._handle_update.bindv([input, node, attr.name]))
			InputsList.push_front(input)

static func update_attribute(attr: Attribute):
	for input in InputsList:
		if input.get_label() == attr.name:
			input.set_val(attr.value)

static func remove_focus():
	for input in InputsList:
		input.deselect()


func _handle_update(input: InspectorInputBase, node: Primitive, attr_name: String):
	node.set_attribute(attr_name, input.get_val())

func _input_scene_from_attr_type(attr_type: AttributeType.AttributeType):
	match attr_type:
		AttributeType.AttributeType.Vector3:
			return preload("res://scenes/user-interface/inspector_import_vector3.tscn")
		AttributeType.AttributeType.Color:
			return preload("res://scenes/user-interface/inspector_import_color.tscn")
		AttributeType.AttributeType.Float, AttributeType.AttributeType.Int:
			return preload("res://scenes/user-interface/inspector_import_float.tscn")
		AttributeType.AttributeType.StringOption:
			return preload("res://scenes/user-interface/inspector_import_string_option.tscn")
		AttributeType.AttributeType.UnEditable:
			return preload("res://scenes/user-interface/inspector_import_uneditable.tscn")
		AttributeType.AttributeType.Binary:
			return preload("res://scenes/user-interface/inspector_import_binary.tscn")
		AttributeType.AttributeType.Boolean:
			return preload("res://scenes/user-interface/inspector_import_boolean.tscn")
	return preload("res://scenes/user-interface/inspector_import_base.tscn")

func _update_world_stats():
	var create_objects_count := 0
	for e in Editor.created_objects:
		if e == null: continue
		create_objects_count += 1
	
	$InspectorPanel/TabContainer/World/VBoxContainer/WorldPoints.text = "World points: " + str(Root.WorldHolder.get_children().size())
	$InspectorPanel/TabContainer/World/VBoxContainer/CreatedObjects.text = "Created objects: " + str(create_objects_count)

func _on_editor_nodes_selected():
	Inspector.reload_attribute_list()

func _on_editor_attribute_update(_node, attr):
	Inspector.update_attribute(attr)

func _on_editor_tree_change(_p):
	_update_world_stats()

func _on_loading_wrapper_loading_update():
	_update_world_stats()
