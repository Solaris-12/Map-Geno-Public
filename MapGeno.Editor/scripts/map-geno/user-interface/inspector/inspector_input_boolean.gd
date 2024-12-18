class_name InspectorInputBoolean extends InspectorInputBase

@onready var check_button: CheckButton = $Layout/CheckButton

func set_label(txt: String):
	super.set_label(txt)
	check_button.text = txt.capitalize()

func get_val():
	return bool(check_button.button_pressed)

func set_val(val):
	check_button.button_pressed = bool(val)

func _on_check_button_toggled(_toggled_on):
	self.update.emit()
