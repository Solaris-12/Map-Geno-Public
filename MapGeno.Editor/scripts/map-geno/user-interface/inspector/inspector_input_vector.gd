class_name InspectorInputVector extends InspectorInputBase

@onready var input_x = $Layout/InputX
@onready var input_y = $Layout/InputY
@onready var input_z = $Layout/InputZ

var value: Vector3 = Vector3()

func get_val() -> Vector3:
	return value

func set_val(val: Vector3):
	value = val
	input_x.text = str(val.x)
	input_y.text = str(val.y)
	input_z.text = str(val.z)


func _input(_event):
	if Input.is_action_just_pressed("ui_accept") and (input.has_focus() or input_x.has_focus() or input_y.has_focus() or input_z.has_focus()):
		value.x = InputUtils.parse_float(input_x)
		value.y = InputUtils.parse_float(input_y)
		value.z = InputUtils.parse_float(input_z)
		self.update.emit()
