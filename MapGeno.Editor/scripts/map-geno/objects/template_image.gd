class_name TemplateImage extends Primitive

var mesh_instance: MeshInstance3D

func _init(obj_name: String, attrs: Attributes, obj_tpe: ObjectType.ObjectType, nd: Area3D):
	super._init(obj_name, attrs, obj_tpe, nd)

	var texture_path = attrs.get_value("texture_path")
	print(texture_path)
	var image = Image.load_from_file(texture_path)
	var texture = ImageTexture.create_from_image(image)

	var sprite = nd.get_node("Sprite") as Sprite3D
	sprite.texture = texture

	nd.scale = attrs.get_value("scale")
	nd.rotation_degrees = attrs.get_value("rotation")

static func create_template(obj_id: int, obj_name: String, obj_tpe: ObjectType.ObjectType, pos: Vector3, rot: Vector3, scl: Vector3, texture_path: String) -> TemplateImage:
	var scene = preload("res://scenes/objects/template_image.tscn")
	var scene_instance = scene.instantiate()
	var r_node = scene_instance.get_node(".")

	var attrs = Attributes.new([
		Attribute.new("id", AttributeType.AttributeType.UnEditable, obj_id),
		Attribute.new("parent_id", AttributeType.AttributeType.UnEditable, null),
		Attribute.new("position", AttributeType.AttributeType.Vector3, pos),
		Attribute.new("rotation", AttributeType.AttributeType.Vector3, rot),
		Attribute.new("scale", AttributeType.AttributeType.Vector3, scl),
		Attribute.new("texture_path", AttributeType.AttributeType.String, texture_path)
	])
	var instance = TemplateImage.new(obj_name, attrs, obj_tpe, r_node)
	attrs.attribute_changed.connect(instance._handle_attribute_change)

	return instance

static func create_default_template(obj_id: int, obj_name: String, texture_path: String) -> TemplateImage:
	return TemplateImage.create_template(obj_id, obj_name, ObjectType.ObjectType.TemplateImage, Vector3.ZERO, Vector3.ZERO, Vector3.ONE, texture_path)

static func from_self(obj_id: int, nd: TemplateImage) -> TemplateImage:
	return TemplateImage.create_template(obj_id, ObjectSelectLabel.object_copy_name_generator(obj_id, nd.object_name), nd.object_type, nd.get_attribute("position"), nd.get_attribute("rotation"), nd.get_attribute("scale"), nd.get_attribute("color"))


func on_selected():
	super.on_selected()

func on_deselected():
	super.on_deselected()


func _handle_attribute_change(attr: Attribute):
	super._handle_attribute_change(attr)

	match attr.name:
		"rotation":
			node.rotation_degrees = attr.get_value()
		"scale":
			node.scale = attr.get_value()
		"texture_path":
			var texture_path = attr.get_value()
			var image = Image.load_from_file(texture_path)
			var texture = ImageTexture.create_from_image(image)

			var sprite = node.get_node("Sprite") as Sprite3D
			sprite.texture = texture
