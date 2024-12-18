class_name InpectorInputColor extends InspectorInputBase

func get_val():
	return input.color

func set_val(val):
	input.color = Color(val)

func _on_input_color_changed(_c):
	self.update.emit()
