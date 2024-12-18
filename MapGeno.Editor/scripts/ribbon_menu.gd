extends MenuBar

@onready var file_menu_button = $FileMenuButton
@onready var world_menu_button = $WorldMenuButton
@onready var export_objects_wrapper = $"../Editor/ObjectCreateLayer/ExportObjectsLayer/ExportObjectsWrapper"
@onready var ui_wrapper = $"../.."

func _ready():
	var file_popup = file_menu_button.get_popup()
	file_popup.id_pressed.connect(_file_menu_button_id_pressed)
	var world_popup = world_menu_button.get_popup()
	world_popup.id_pressed.connect(_world_menu_button_id_pressed)

func _file_menu_button_id_pressed(id: int):
	print("File ribbon menu: ", id)
	match id:
		0:
			$ImportRoomcastDialog.popup()
		1:
			export_objects_wrapper.visible = true
		2:
			$ImportRoomObjectsDialog.popup()
		4:
			$"../Editor/SettingsModal".show()

func _world_menu_button_id_pressed(id: int):
	print("World ribbon menu: ", id)
	match id:
		0:
			for child in Root.WorldHolder.get_children():
				Root.WorldHolder.remove_child(child)
			Editor.SingleTon.tree_change.emit()
		1:
			$AddTemplateImageDialog.popup()

func _on_input_file_dialog_file_selected(path):
	RoomCastImporter.import(path)

func _on_import_room_objects_dialog_file_selected(path):
	RoomObjectsImporter.import(path)

func _on_add_template_image_dialog_file_selected(path):
	var node = TemplateImage.create_default_template(Editor.NewObjectId, ObjectType.translate(ObjectType.ObjectType.TemplateImage) + " " + str(Editor.NewObjectId), path)
	Root.ObjectHolder.add_child(node)
	Editor.add_created_object(node)
	node.has_been_selected.connect(Editor.select_one_object)
	node.attribute_changed.connect(Editor.SingleTon._handle_attribute_change.bind(node))
