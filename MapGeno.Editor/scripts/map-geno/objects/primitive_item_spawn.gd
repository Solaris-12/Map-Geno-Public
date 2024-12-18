class_name PrimitiveItemSpawn extends Primitive

var mesh_instance: MeshInstance3D
var material = StandardMaterial3D

func _init(obj_name: String, attrs: Attributes, obj_tpe: ObjectType.ObjectType, nd: Area3D, label_parent = ObjectList.SingleTon.root):
	super._init(obj_name, attrs, obj_tpe, nd, label_parent)

	mesh_instance = nd.get_node("Mesh") as MeshInstance3D
	var mesh = TorusMesh.new()
	mesh.rings = 5
	mesh.ring_segments = 12

	material = StandardMaterial3D.new()
	material.albedo_color = Color(0.7, 0.1, 0.65)
	mesh.material = material

	mesh_instance.mesh = mesh

	nd.scale = attrs.get_value("scale")
	nd.rotation_degrees = attrs.get_value("rotation")

static func create_item_spawn(obj_id: int, obj_name: String, obj_tpe: ObjectType.ObjectType, pos: Vector3, rot: Vector3, scl: Vector3, item_type: String, label_parent = ObjectList.SingleTon.root) -> PrimitiveItemSpawn:
	var scene = preload("res://scenes/objects/primitive_item_spawn.tscn")
	var scene_instance = scene.instantiate()
	var r_node = scene_instance.get_node(".")

	var attrs = Attributes.new([
		Attribute.new("id", AttributeType.AttributeType.UnEditable, obj_id),
		Attribute.new("parent_id", AttributeType.AttributeType.UnEditable, null),
		Attribute.new("position", AttributeType.AttributeType.Vector3, pos),
		Attribute.new("rotation", AttributeType.AttributeType.Vector3, rot),
		Attribute.new("scale", AttributeType.AttributeType.Vector3, scl),
		Attribute.new("item_type", AttributeType.AttributeType.StringOption, item_type)
	])
	var instance = PrimitiveItemSpawn.new(obj_name, attrs, obj_tpe, r_node, label_parent)
	attrs.attribute_changed.connect(instance._handle_attribute_change)

	return instance

static func create_default(obj_id: int, obj_name: String) -> PrimitiveItemSpawn:
	return PrimitiveItemSpawn.create_item_spawn(obj_id, obj_name, ObjectType.ObjectType.ItemSpawn, Vector3.ZERO, Vector3.ZERO, Vector3.ONE, "")

static func from_self(obj_id: int, nd: PrimitiveItemSpawn) -> PrimitiveItemSpawn:
	return PrimitiveItemSpawn.create_item_spawn(obj_id, ObjectSelectLabel.object_copy_name_generator(obj_id, nd.object_name), ObjectType.ObjectType.ItemSpawn, nd.get_attribute("position"), nd.get_attribute("rotation"), nd.get_attribute("scale"), nd.get_attribute("item_type"))


func on_selected():
	super.on_selected()
	set_outline(true)

func on_deselected():
	super.on_deselected()
	set_outline(false)


func set_outline(outline: bool):
	if outline:
		var outline_material = preload("res://assets/shaders/3d_outline.material")
		material.next_pass = outline_material
	else:
		material.next_pass = null

func _handle_attribute_change(attr: Attribute):
	super._handle_attribute_change(attr)

	match attr.name:
		"rotation":
			node.rotation_degrees = attr.get_value()
		"scale":
			node.scale = attr.get_value()
