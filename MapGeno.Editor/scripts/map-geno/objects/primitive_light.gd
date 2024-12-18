class_name PrimitiveLight extends Primitive

var mesh_instance: MeshInstance3D
var light_instance: OmniLight3D

func _init(obj_name: String, attrs: Attributes, obj_tpe: ObjectType.ObjectType, nd: Area3D, label_parent = ObjectList.SingleTon.root):
	super._init(obj_name, attrs, obj_tpe, nd, label_parent)

	mesh_instance = nd.get_node("Mesh") as MeshInstance3D
	light_instance = nd.get_node("Light") as OmniLight3D

	light_instance.light_color = attrs.get_value("color")
	light_instance.omni_range = attrs.get_value("light_range")
	light_instance.light_energy = attrs.get_value("light_intensity")
	light_instance.shadow_enabled = attrs.get_value("light_shadows")

	Root.Camera.on_move.connect(_handle_light_instance_process)


static func create_light(obj_id: int, obj_name: String, pos: Vector3, clr: Color, light_intensity: float, light_range: float, light_shadows = true, label_parent = ObjectList.SingleTon.root) -> PrimitiveLight:
	var scene = preload("res://scenes/objects/primitive_light.tscn")
	var scene_instance = scene.instantiate()
	var r_node = scene_instance.get_node(".")

	var attrs = Attributes.new([
		Attribute.new("id", AttributeType.AttributeType.UnEditable, obj_id),
		Attribute.new("parent_id", AttributeType.AttributeType.UnEditable, null),
		Attribute.new("position", AttributeType.AttributeType.Vector3, pos),
		Attribute.new("color", AttributeType.AttributeType.Color, clr),
		Attribute.new("light_intensity", AttributeType.AttributeType.Float, light_intensity),
		Attribute.new("light_range", AttributeType.AttributeType.Float, light_range),
		Attribute.new("light_shadows", AttributeType.AttributeType.Boolean, light_shadows)
	])
	var instance = PrimitiveLight.new(obj_name, attrs, ObjectType.ObjectType.Light, r_node, label_parent)
	attrs.attribute_changed.connect(instance._handle_attribute_change)

	return instance

static func create_default(obj_id: int, obj_name: String) -> PrimitiveLight:
	return PrimitiveLight.create_light(obj_id, obj_name, Vector3.ZERO, Color.WHITE, 1, 3)

static func from_self(obj_id: int, nd: PrimitiveLight) -> PrimitiveLight:
	return PrimitiveLight.create_light(obj_id, ObjectSelectLabel.object_copy_name_generator(obj_id, nd.object_name), nd.get_attribute("position"), nd.get_attribute("color"), nd.get_attribute("light_intensity"), nd.get_attribute("light_range"), nd.get_attribute("light_shadows"))


func _handle_attribute_change(attr: Attribute):
	super._handle_attribute_change(attr)

	match attr.name:
		"color":
			light_instance.light_color = attr.get_value()
		"light_intensity":
			light_instance.light_energy = attr.get_value()
		"light_range":
			light_instance.omni_range = attr.get_value()
		"light_shadows":
			light_instance.shadow_enabled = attr.get_value()

func _handle_light_instance_process(pos):
	if node.position != pos:
		node.look_at(pos)

