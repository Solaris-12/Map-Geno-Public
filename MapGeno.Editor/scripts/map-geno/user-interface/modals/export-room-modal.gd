extends CanvasLayer

@onready var export_objects_wrapper = $ExportObjectsWrapper
@onready var room_type_select = $ExportObjectsWrapper/ExportObjectsPanel/ExportObjectsLayout/ExportObjectsRoomName
@onready var file_dialog = $ExportObjectsWrapper/ExportObjectsPanel/ExportObjectsLayout/FileInputLayout/FileDialog
@onready var author_input = $ExportObjectsWrapper/ExportObjectsPanel/ExportObjectsLayout/AuthorInput
@onready var file_path = $ExportObjectsWrapper/ExportObjectsPanel/ExportObjectsLayout/FileInputLayout/FilePath
@onready var room_name_input = $ExportObjectsWrapper/ExportObjectsPanel/ExportObjectsLayout/RoomNameInput
@onready var description_area = $ExportObjectsWrapper/ExportObjectsPanel/ExportObjectsLayout/DescriptionArea


func _ready():
	room_type_select.set_label("room_type")


func _on_select_file_pressed():
	file_dialog.popup()


func _on_confirm_button_pressed():
	if not file_path.text.is_empty():
		var room_name: String = room_name_input.text
		var f_path: String = file_path.text
		var f_name = InputUtils.sanitize_string(room_name) + ".json"
		if f_path.ends_with("/"):
			f_path += f_name
		else: 
			f_path += "/" + f_name
		var author = author_input.text
		var description = description_area.text
		var room_name_type = room_type_select.get_val()
		RoomObjectsExporter. export (f_path, room_name_type, {"author": author, "name": room_name, "description": description})
		export_objects_wrapper.visible = false


func _on_cancel_button_pressed():
	export_objects_wrapper.visible = false


func _on_file_dialog_file_selected(path):
	file_path.text = path

func _input(_event):
	if export_objects_wrapper.visible:
		if Input.is_action_just_pressed("ui_accept"):
			_on_confirm_button_pressed()
		elif Input.is_action_just_pressed("ui_cancel"):
			_on_cancel_button_pressed()


func _on_file_dialog_dir_selected(dir):
	file_path.text = dir
