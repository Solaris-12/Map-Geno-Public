class_name ObjectList extends Control

@onready var object_holder: Tree = $ObjectEditorPanel/ObjectEditorLayout/ObjectHolderTree
@onready var timer = $Timer

static var SingleTon: ObjectList
static var reload_disabled := false

var context_menu: ObjectListContextMenu
var root: TreeItem

func _ready():
	SingleTon = self
	self.root = self.object_holder.create_item()
	self.root.set_text(0, "Root")
	self.object_holder.empty_clicked.connect(handle_empty_click)

static func create_object_label(object_name: String, object_type: ObjectType.ObjectType, parent = SingleTon.root) -> ObjectSelectLabel:
	var item = SingleTon.object_holder.create_item(parent if parent != null else SingleTon.root)
	item.set_icon(0, SingleTon.icon_from_type(object_type))
	item.set_text(0, object_name)
	item.set_script(preload("res://scripts/object_select_label.gd"))
	return item

static func reload_list(_obj):
	if reload_disabled:
		return

	print_debug("Reloading list")

	# Clear existing items and initialize root
	SingleTon.object_holder.clear()
	SingleTon.root = SingleTon.object_holder.create_item()
	SingleTon.root.set_text(0, "Root")

	# Map to store objects by their ID for quick lookup
	var object_map = {}
	for obj in Editor.created_objects:
		if obj == null:
			continue
		object_map[str(obj.get_id())] = obj

	# List to store sorted objects and a set to track visited objects
	var sorted_objects = []
	var visited = {}

	# Visit each object, ensuring that parents are visited before their children
	for obj in Editor.created_objects:
		if obj == null:
			continue
		visit(obj, object_map, sorted_objects, visited)

	# Create labels for each object, linking to their parent or root if no parent
	for obj in sorted_objects:
		if obj.get_parent_id() != null and object_map.has(str(obj.get_parent_id())):
			var parent = object_map[str(obj.get_parent_id())]
			obj.create_label(obj.object_name, parent.label)
		else:
			obj.create_label(obj.object_name, SingleTon.root)

# Helper function to visit nodes using DFS
static func visit(obj, object_map, sorted_objects, visited):
	if obj.get_id() in visited:
		return

	visited[obj.get_id()] = true

	# Visit the parent first if it exists and hasn't been visited
	if obj.get_parent_id() != null and object_map.has(str(obj.get_parent_id())):
		visit(object_map[str(obj.get_parent_id())], object_map, sorted_objects, visited)

	# Add the current object to the sorted list after its parent
	sorted_objects.append(obj)

static func find_obj_by_id(id: int):
	for obj in Editor.created_objects:
		if obj == null:
			continue
		if obj.get_id() == id:
			return obj
	return null

static func find_objs_by_parent(parent_id: int):
	var output := [] as Array[Primitive]
	for obj in Editor.created_objects:
		if obj == null:
			continue
		var par_id = obj.get_parent_id()
		if par_id != null and int(par_id) == parent_id:
			output.push_back(obj)
	return output

func _input(event):
	if event is InputEventMouseButton:
		if event.is_echo() or event.is_released():
			return
		if context_menu != null and (event.position.x < 220 or event.position.x > context_menu.panel.position.x + context_menu.panel.size.x):
			context_menu.hide()
			context_menu.queue_free()
		if event.position.x <= 220:
			if context_menu != null:
				context_menu.hide()
				context_menu.queue_free()
			if event.button_index == MOUSE_BUTTON_RIGHT and Editor.selected_nodes.size() > 0:
				context_menu = preload("res://scenes/user-interface/object_list_context_menu.tscn").instantiate()
				UserInterface.SingleTon.add_child(context_menu)
				context_menu.move_to(Vector2(220, event.position.y))

func call_reload_deferred(time := 0.2):
	timer.one_shot = true
	timer.start(time)

func on_create_object_label_ready(node: ObjectSelectLabel, object_name: String, object_type: ObjectType.ObjectType):
	node.set_object_name(object_name)
	node.set_icon_from_type(object_type)

func icon_from_type(type: ObjectType.ObjectType):
	match type:
		ObjectType.ObjectType.Cube:
			return preload("res://assets/icons/cube-icon.png")
		ObjectType.ObjectType.Sphere:
			return preload("res://assets/icons/sphere-icon.png")
		ObjectType.ObjectType.Capsule:
			return preload("res://assets/icons/capsule-icon.png")
		ObjectType.ObjectType.Cylinder:
			return preload("res://assets/icons/cylinder-icon.png")
		ObjectType.ObjectType.Plane:
			return preload("res://assets/icons/plane-icon.png")
		ObjectType.ObjectType.Light:
			return preload("res://assets/icons/light-icon.png")
		ObjectType.ObjectType.Prefab:
			return preload("res://assets/icons/template-icon.png")
		ObjectType.ObjectType.ItemSpawn:
			return preload("res://assets/icons/sword-item-icon.png")
		ObjectType.ObjectType.SpawnPoint:
			return preload("res://assets/icons/point-mark-icon.png")		
		ObjectType.ObjectType.Door:
			return preload("res://assets/icons/door-icon.png")
		ObjectType.ObjectType.Group:
			return preload("res://assets/icons/folder-icon.png")
		ObjectType.ObjectType.TemplateImage:
			return preload("res://assets/icons/image-icon.png")

func handle_empty_click(_pos, _mbi):
	Editor.select_multiple_objects([])


func _on_timer_timeout():
	ObjectList.reload_list(null)
