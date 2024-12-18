class_name Attribute extends Object

var name: String
var type: AttributeType.AttributeType
var value

func _init(atr_name: String, atr_type: AttributeType.AttributeType, val = null):
	name = atr_name
	type = atr_type
	value = val

func get_value():
	return value

func set_value(val):
	value = val

func duplicate() -> Attribute:
	return Attribute.new(self.name, self.type, self.value)
