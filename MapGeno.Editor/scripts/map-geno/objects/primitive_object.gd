class_name PrimitiveObject extends Primitive

const PLANE_SCALING_FACTOR = 5

var mesh_instance: MeshInstance3D
var collision_instance: CollisionShape3D
var material: StandardMaterial3D

func _init(obj_name: String, attrs: Attributes, obj_tpe: ObjectType.ObjectType, nd: Area3D, label_parent = ObjectList.SingleTon.root):
	super._init(obj_name, attrs, obj_tpe, nd, label_parent)
	material = StandardMaterial3D.new()

	mesh_instance = nd.get_node("Mesh") as MeshInstance3D
	mesh_instance.mesh = _mesh_from_object_type(obj_tpe)
	mesh_instance.mesh.material = material
	material.albedo_color = attrs.get_value("color")
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_HASH

	collision_instance = nd.get_node("Collision") as CollisionShape3D
	collision_instance.shape = _shape_from_object_type(obj_tpe)

	if self.object_type == ObjectType.ObjectType.Plane:
		nd.scale = attrs.get_value("scale") * PLANE_SCALING_FACTOR
	else:
		nd.scale = attrs.get_value("scale")
	nd.rotation_degrees = attrs.get_value("rotation")

static func create_object(obj_id: int, obj_name: String, obj_tpe: ObjectType.ObjectType, pos: Vector3, rot: Vector3, scl: Vector3, clr: Color, label_parent = ObjectList.SingleTon.root) -> PrimitiveObject:
	var scene = preload("res://scenes/objects/primitive_object.tscn")
	var scene_instance = scene.instantiate()
	var r_node = scene_instance.get_node(".")

	var attrs = Attributes.new([
		Attribute.new("id", AttributeType.AttributeType.UnEditable, obj_id),
		Attribute.new("parent_id", AttributeType.AttributeType.UnEditable, null),
		Attribute.new("position", AttributeType.AttributeType.Vector3, pos),
		Attribute.new("rotation", AttributeType.AttributeType.Vector3, rot),
		Attribute.new("scale", AttributeType.AttributeType.Vector3, scl),
		Attribute.new("color", AttributeType.AttributeType.Color, clr)
	])
	var instance = PrimitiveObject.new(obj_name, attrs, obj_tpe, r_node, label_parent)
	attrs.attribute_changed.connect(instance._handle_attribute_change)

	return instance

static func create_default_object(obj_id: int, obj_name: String, obj_tpe: ObjectType.ObjectType) -> PrimitiveObject:
	return PrimitiveObject.create_object(obj_id, obj_name, obj_tpe, Vector3.ZERO, Vector3.ZERO, Vector3.ONE, Color.GRAY)

static func from_self(obj_id: int, nd: PrimitiveObject) -> PrimitiveObject:
	return PrimitiveObject.create_object(obj_id, ObjectSelectLabel.object_copy_name_generator(obj_id, nd.object_name), nd.object_type, nd.get_attribute("position"), nd.get_attribute("rotation"), nd.get_attribute("scale"), nd.get_attribute("color"))


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

func _mesh_from_object_type(obj_type: ObjectType.ObjectType):
	match obj_type:
		ObjectType.ObjectType.Cube:
			return BoxMesh.new()
		ObjectType.ObjectType.Sphere:
			return SphereMesh.new()
		ObjectType.ObjectType.Capsule:
			return CapsuleMesh.new()
		ObjectType.ObjectType.Cylinder:
			return CylinderMesh.new()
		ObjectType.ObjectType.Plane:
			return PlaneMesh.new()

func _shape_from_object_type(obj_type: ObjectType.ObjectType):
	match obj_type:
		ObjectType.ObjectType.Cube:
			return BoxShape3D.new()
		ObjectType.ObjectType.Sphere:
			return SphereShape3D.new()
		ObjectType.ObjectType.Capsule:
			return CapsuleShape3D.new()
		ObjectType.ObjectType.Cylinder:
			return CylinderShape3D.new()
		ObjectType.ObjectType.Plane:
			var mesh = BoxShape3D.new()
			mesh.size = Vector3(2, 0.05, 2)
			return mesh

func _handle_attribute_change(attr: Attribute):
	super._handle_attribute_change(attr)

	match attr.name:
		"rotation":
			node.rotation_degrees = attr.get_value()
		"scale":
			if self.object_type == ObjectType.ObjectType.Plane:
				node.scale = attr.get_value() * PLANE_SCALING_FACTOR
			else:
				node.scale = attr.get_value()
		"color":
			var clr: Color = attr.get_value()
			material.albedo_color = clr
