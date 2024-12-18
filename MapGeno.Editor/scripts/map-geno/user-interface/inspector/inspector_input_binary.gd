class_name InpectorInputBinary extends InspectorInputBase

@onready var open_button = $Layout/VBox/OpenButton
@onready var value = $Layout/VBox/Value

func get_val():
	return max(0, int(value.text))

func set_val(val):
	value.text = str(val)

func _on_option_value_text_changed(_t):
	InputUtils.parse_int(value)
	update.emit()

func _on_open_button_pressed():
	BinaryEditor.open(value)
