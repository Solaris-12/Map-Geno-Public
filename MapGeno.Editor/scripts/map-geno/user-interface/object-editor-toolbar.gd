extends HBoxContainer

@onready var object_create_wrapper = $"../../../../../../ObjectCreateLayer/ObjectCreateWrapper"


func _on_new_object_button_pressed():
	object_create_wrapper.visible = true

