class_name InspectorInputBase extends Panel

signal update

@onready var layout = $Layout
@onready var label = $Layout/Label
@onready var input = $Layout/Input

var attr_name: String


func get_label():
	return attr_name

func set_label(txt: String):
	attr_name = txt
	label.text = txt.capitalize()

func get_val():
	return input.text

func set_val(val):
	input.text = str(val)

func deselect():
	for node in layout.get_children():
		if node is LineEdit:
			node.call_deferred("release_focus")

func _input(_event):
	if Input.is_action_just_pressed("ui_accept") and input.has_focus():
		self.update.emit()
