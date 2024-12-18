class_name ObjectListContextMenu extends CanvasLayer

@onready var panel = $Panel
@onready var remove_button = $Panel/VBoxContainer/RemoveButton
@onready var duplicate_button = $Panel/VBoxContainer/DuplicateButton
@onready var parent_select: OptionButton = $Panel/VBoxContainer/ParentSelect
var null_id: int = 999e5

func _ready():
	parent_select.add_item("<null>", null_id)
	for obj in Editor.created_objects:
		if obj == null:
			continue
		if obj.object_type == ObjectType.ObjectType.Group:
			parent_select.add_item(obj.object_name, obj.get_id())

func move_to(pos: Vector2):
	var end_pos = pos
	if end_pos.y + panel.size.y > get_window().size.y:
		end_pos.y = get_window().size.y - panel.size.y
	
	panel.position = end_pos


func _on_remove_button_pressed():
	UserInterface.SingleTon._on_remove_object_button_pressed()
	hide()

func _on_duplicate_button_pressed():
	UserInterface.SingleTon._on_duplicate_object_button_pressed()
	hide()

func _on_parent_select_item_selected(index):
	var id = parent_select.get_item_id(index)
	var parent_id: Variant = null if id == null_id else id
	print("Selected parent id = ", parent_id)
	var parent = ObjectList.find_obj_by_id(parent_id) if parent_id != null else null
	for obj in Editor.selected_nodes:
		if parent != null and obj.get_id() == parent.get_id():
			continue
		obj.set_parent(parent)
	hide()


func _on_group_button_pressed():
	var node = PrimitiveGroup.create_group(Editor.NewObjectId, "Group", Vector3(0,0,0))
	Root.ObjectHolder.add_child(node)
	Editor.add_created_object(node)
	Editor.SingleTon.tool_change.connect(node.on_tool_change)
	node.has_been_selected.connect(Editor.select_one_object)
	node.attribute_changed.connect(Editor.SingleTon._handle_attribute_change.bind(node))
	for obj in Editor.selected_nodes:
		obj.set_parent(node)
	hide()
