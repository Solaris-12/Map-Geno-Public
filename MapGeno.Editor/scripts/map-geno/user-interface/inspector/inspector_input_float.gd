class_name InspectorInputFloat extends InspectorInputBase

func get_val():
	return InputUtils.parse_float(input)

func set_val(val):
	input.text = str(float(val))

func _input(_event):
	if Input.is_action_just_pressed("ui_accept") and input.has_focus():
		self.update.emit()
