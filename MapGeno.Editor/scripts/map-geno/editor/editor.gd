class_name Editor extends Node

signal tool_change
signal selection_change
signal tree_change(obj: Variant)
signal attribute_update(node: Primitive, attr: Attribute)

static var SingleTon: Editor
static var created_objects: Array[Primitive] = []
static var NewObjectId: int = 0
static var current_tool: ToolType.ToolType = ToolType.ToolType.CursorTool
static var selected_nodes: Array[Primitive] = []

func _ready():
	SingleTon = self
	self.tree_change.connect(ObjectList.reload_list)

static func create_new_object(ot: ObjectType.ObjectType):
	var object_name = ObjectType.translate(ot) + " " + str(NewObjectId)
	var primitive_instance = SingleTon._primitive_default_from_type(NewObjectId, object_name, ot)
	Root.ObjectHolder.add_child(primitive_instance)
	primitive_instance.has_been_selected.connect(select_one_object)
	primitive_instance.attribute_changed.connect(SingleTon._handle_attribute_change.bind(primitive_instance))
	SingleTon.tool_change.connect(primitive_instance.on_tool_change)
	add_created_object(primitive_instance)
	select_one_object(primitive_instance)

static func create_new_object_from_attributes(ot: ObjectType.ObjectType, attrs: Attributes):
	var object_name = ObjectType.translate(ot) + " " + str(NewObjectId)
	var instance: Primitive
	match ot:
		ObjectType.ObjectType.None:
			instance = Primitive.create(NewObjectId, object_name, attrs.get_value("position"))
		ObjectType.ObjectType.Cube, ObjectType.ObjectType.Sphere, ObjectType.ObjectType.Capsule, ObjectType.ObjectType.Cylinder, ObjectType.ObjectType.Plane:
			instance = PrimitiveObject.create_object(NewObjectId, object_name, ot, attrs.get_value("position"), attrs.get_value("rotation"), attrs.get_value("scale"), attrs.get_value("color"))
		ObjectType.ObjectType.Light:
			instance = PrimitiveLight.create_light(NewObjectId, object_name, attrs.get_value("position"), attrs.get_value("color"), attrs.get_value("light_intensity"), attrs.get_value("light_range"))
		ObjectType.ObjectType.Prefab:
			instance = PrimitivePrefab.create_prefab(NewObjectId, object_name, ot, attrs.get_value("position"), attrs.get_value("rotation"), attrs.get_value("scale"), attrs.get_value("prefab_type"))
		ObjectType.ObjectType.ItemSpawn:
			instance = PrimitiveItemSpawn.create_item_spawn(NewObjectId, object_name, ot, attrs.get_value("position"), attrs.get_value("rotation"), attrs.get_value("scale"), attrs.get_value("item_type"))
		ObjectType.ObjectType.SpawnPoint:
			instance = PrimitiveSpawnpoint.create_spawn_point(NewObjectId, object_name, ot, attrs.get_value("position"), attrs.get_value("rotation"), attrs.get_value("role_type")) 
		ObjectType.ObjectType.Door:
			instance = PrimitiveDoor.create_door(NewObjectId, object_name, ot, attrs.get_value("position"), attrs.get_value("rotation"), attrs.get_value("scale"), attrs.get_value("door_type"), attrs.get_value("lock_type"), attrs.get_value("permissions"), attrs.get_value("is_open"), attrs.get_value("allow_106"))
	Root.ObjectHolder.add_child(instance)
	instance.has_been_selected.connect(select_one_object)
	instance.attribute_changed.connect(SingleTon._handle_attribute_change.bind(instance))
	SingleTon.tool_change.connect(instance.on_tool_change)
	add_created_object(instance)
	return instance

static func add_created_object(obj: Primitive):
	created_objects.push_front(obj)
	while ObjectList.find_obj_by_id(NewObjectId) != null:
		NewObjectId += 1
	SingleTon.tree_change.emit(obj)

static func select_one_object(obj: Primitive, append: bool = false, selected = true):
	if not selected:
		deselect_multiple_objects([obj])
		return

	if not append:
		Editor.select_multiple_objects([obj])
		return
	var new_selection = selected_nodes.duplicate()
	new_selection.append(obj)
	Editor.select_multiple_objects(new_selection)

static func select_multiple_objects(objs: Array[Primitive]):
	Editor.deselect_multiple_objects(selected_nodes)

	selected_nodes = objs
	for obj in objs:
		if obj:
			obj.call_deferred("on_selected")
	SingleTon.selection_change.emit()

static func deselect_multiple_objects(objs: Array[Primitive]):
	for obj in objs:
		if obj.is_queued_for_deletion():
			continue
		if obj and selected_nodes.has(obj):
			var obj_index = selected_nodes.find(obj)
			obj.on_deselected()
			selected_nodes.remove_at(obj_index)
	SingleTon.selection_change.emit()



static func select_tool(tool_type: ToolType.ToolType):
	current_tool = tool_type
	SingleTon.tool_change.emit(current_tool)

func _primitive_default_from_type(object_id: int, object_name: String, object_type: ObjectType.ObjectType) -> Primitive:
	print("Creating primitive ", object_type, " instance")
	match object_type:
		ObjectType.ObjectType.None:
			return Primitive.create_default(object_id, object_name)
		ObjectType.ObjectType.Cube, ObjectType.ObjectType.Sphere, ObjectType.ObjectType.Capsule, ObjectType.ObjectType.Cylinder, ObjectType.ObjectType.Plane:
			return PrimitiveObject.create_default_object(object_id, object_name, object_type)
		ObjectType.ObjectType.Light:
			return PrimitiveLight.create_default(object_id, object_name)
		ObjectType.ObjectType.Prefab:
			return PrimitivePrefab.create_default(object_id, object_name)
		ObjectType.ObjectType.ItemSpawn:
			return PrimitiveItemSpawn.create_default(object_id, object_name)
		ObjectType.ObjectType.SpawnPoint:
			return PrimitiveSpawnpoint.create_default(object_id, object_name) 
		ObjectType.ObjectType.Door:
			return PrimitiveDoor.create_default(object_id, object_name)
		ObjectType.ObjectType.Group:
			return PrimitiveGroup.create_default(object_id, object_name)
	return null

func _handle_attribute_change(attribute: Attribute, node: Primitive):
	attribute_update.emit(node, attribute)
