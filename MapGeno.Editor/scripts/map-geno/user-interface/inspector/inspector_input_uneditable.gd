class_name InspectorInputUnEditable extends InspectorInputBase
@onready var value = $Layout/Value

func get_val():
	return value.text

func set_val(val):
	value.text = str(val)
