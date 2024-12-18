class_name Attributes extends Object

signal attribute_changed(attr: Attribute)

var attributes: Array

func _init(attrs = []):
	attributes = attrs

func add_attribute(attr: Attribute):
	attributes.push_front(attr)

func get_value(attr_name: String) -> Variant:
	for attr: Attribute in attributes:
		if attr.name == attr_name:
			return attr.get_value()

	return null

func set_value(attr_name: String, val: Variant, emit := true):
	for attr: Attribute in attributes:
		if attr.name == attr_name:
			attr.set_value(val)
			if emit:
				attribute_changed.emit(attr)
			return

func duplicate() -> Attributes:
	var new_array = []
	for attr: Attribute in get_attributes():
		new_array.push_front(attr.duplicate())
	return Attributes.new(new_array)

func get_attributes() -> Array:
	return attributes
