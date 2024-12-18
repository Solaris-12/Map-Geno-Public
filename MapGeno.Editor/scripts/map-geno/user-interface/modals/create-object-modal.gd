extends CanvasLayer

@onready var object_create_wrapper = $ObjectCreateWrapper
@onready var create_object_list = $ObjectCreateWrapper/CreateObjectPanel/CreateObjectLayout/CreateObjectList

func _on_confirm_create_object_pressed():
	object_create_wrapper.visible = false
	var selected: PackedInt32Array = create_object_list.get_selected_items()
	if len(selected) > 0:
		Editor.create_new_object(ObjectType.from_int(selected[0]))
	else:
		Editor.create_new_object(ObjectType.ObjectType.Cube)

func _on_cancel_create_object_pressed():
	object_create_wrapper.visible = false

func _input(_event):
	if object_create_wrapper.visible:
		if Input.is_action_just_pressed("ui_accept"):
			_on_confirm_create_object_pressed()
		elif Input.is_action_just_pressed("ui_cancel"):
			_on_cancel_create_object_pressed()
