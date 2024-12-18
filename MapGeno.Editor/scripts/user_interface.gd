class_name UserInterface extends CanvasLayer

static var SingleTon: UserInterface

# Tool buttons
@onready var cursor_tool_button: Button = $UI_Wrapper/Editor/EditorWrapper/GridContainer/EditorToolWrapper/EditorToolLayout/ToolsContainer/CursorToolButton
@onready var move_tool_button: Button = $UI_Wrapper/Editor/EditorWrapper/GridContainer/EditorToolWrapper/EditorToolLayout/ToolsContainer/MoveToolButton
@onready var rotate_tool_button: Button = $UI_Wrapper/Editor/EditorWrapper/GridContainer/EditorToolWrapper/EditorToolLayout/ToolsContainer/RotateToolButton
@onready var scale_tool_button: Button = $UI_Wrapper/Editor/EditorWrapper/GridContainer/EditorToolWrapper/EditorToolLayout/ToolsContainer/ScaleToolButton
@onready var tool_buttons = [cursor_tool_button, move_tool_button, rotate_tool_button, scale_tool_button]

@onready var settings_modal = $UI_Wrapper/Editor/SettingsModal

var undo_list: Array = []
var redo_list: Array = []

func _ready():
	SingleTon = self
	settings_modal.hide()

func start_export(path: String):
	Root.ObjectHolder.export_objects(path, "room")

func _on_editor_tool_wrapper_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.is_pressed():
			Inspector.remove_focus()


func handle_undo():
	if len(undo_list) > 0:
		var state: ObjectState = undo_list.pop_front()
		state.go_here()
		redo_list.push_front(state)

func handle_redo():
	if len(redo_list) > 0:
		var state: ObjectState = redo_list.pop_front()
		state.go_here()
		undo_list.push_front(state)

func _on_undo_button_pressed():
	handle_undo()

func _on_redo_button_pressed():
	handle_redo()


func _on_remove_object_button_pressed():
	print_debug("Removing selected nodes: ", Editor.selected_nodes.size())
	for node in Editor.selected_nodes:
		var index = Editor.created_objects.find(node)
		if index:
			Editor.created_objects.remove_at(index)
		print("Removing ", node, " at ", index)
		node.remove()
	Editor.select_multiple_objects([])


func _on_duplicate_object_button_pressed():
	if Editor.selected_nodes.size() <= 0:
		return

	var new_nodes = [] as Array[Primitive]
	for node in Editor.selected_nodes:
		var primitive_instance = node.from_self(Editor.NewObjectId, node)
		Root.ObjectHolder.add_child(primitive_instance)
		Editor.add_created_object(primitive_instance)
		primitive_instance.has_been_selected.connect(Editor.select_one_object)
		primitive_instance.attribute_changed.connect(Editor.SingleTon._handle_attribute_change.bind(primitive_instance))
		Editor.SingleTon.tool_change.connect(primitive_instance.on_tool_change)
		primitive_instance.on_tool_change(null)
		new_nodes.push_front(primitive_instance)
	Editor.select_multiple_objects(new_nodes)
