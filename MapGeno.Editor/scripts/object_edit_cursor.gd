class_name ObjectEditCursor extends Node3D

@onready var user_interface = $"../../UserInterface"

@onready var x_axis = $Xaxis
@onready var y_axis = $Yaxis
@onready var z_axis = $Zaxis
@onready var x_axis_mesh: MeshInstance3D = $Xaxis/XAxisMesh
@onready var y_axis_mesh: MeshInstance3D = $Yaxis/YAxisMesh
@onready var z_axis_mesh: MeshInstance3D = $Zaxis/ZAxisMesh

signal modified_object

enum MoveDirection {
	None,
	Xaxis,
	Yaxis,
	Zaxis
}

const MOVE_AMPLIFIER = 0.001;
const SCALE_AMPLIFIER = 0.001;
const ROTATION_AMPLIFIER = 0.3;

var current_state: ObjectState
var current_camera: Camera3D
var current_move_direction: MoveDirection
var is_moving: bool = false

func _ready():
	Editor.SingleTon.tool_change.connect(update_tool)
	Editor.SingleTon.attribute_update.connect(_on_attribute_change)
	Editor.SingleTon.selection_change.connect(_on_node_update)

func update_tool(_tool):
	if len(Editor.selected_nodes):
		if Editor.current_tool == ToolType.ToolType.CursorTool:
			_hide_cursor()
		else:
			_show_cursor()


func on_nodes_update():
	if Editor.selected_nodes.size() <= 0:
		_hide_cursor()
		return
	if Editor.current_tool != ToolType.ToolType.CursorTool:
		_show_cursor()

	var sum_position = Vector3()
	for node in Editor.selected_nodes:
		var pos = node.get_attribute("position")
		if pos:
			sum_position += pos
	var average_position = sum_position / Editor.selected_nodes.size()
	position = average_position

func handle_edit(relative: Vector2):
	var x_negative = 1
	var z_negative = 1
	if (Root.Camera.position.x - position.x) > 0:
		x_negative = -1
	if (Root.Camera.position.z - position.z) > 0:
		z_negative = -1

	match Editor.current_tool:
		ToolType.ToolType.MoveTool:
			var movement = Vector3()
			match current_move_direction:
				MoveDirection.Xaxis:
					movement.x += relative.x * MOVE_AMPLIFIER * z_negative * current_camera.position.distance_to(position)
				MoveDirection.Yaxis:
					movement.y -= relative.y * MOVE_AMPLIFIER * current_camera.position.distance_to(position)
				MoveDirection.Zaxis:
					movement.z -= relative.x * MOVE_AMPLIFIER * x_negative * current_camera.position.distance_to(position)
			for node in Editor.selected_nodes:
				if node.get_attribute("position") != null:
					node.set_attribute("position", node.get_attribute("position") + movement)
		ToolType.ToolType.RotateTool:
			var x_angle = relative.x * ROTATION_AMPLIFIER
			var y_angle = -1 * relative.y * ROTATION_AMPLIFIER
			var z_angle = -1 * relative.x * ROTATION_AMPLIFIER
			for node in Editor.selected_nodes:
				if node.get_attribute("position"):
					var rotations = Vector3()
					var movement = node.get_attribute("position")
					match current_move_direction:
						MoveDirection.Xaxis:
							movement = ObjectEditCursor.rotate_vector_around_point(movement, position, x_angle, Vector3.RIGHT)
							rotations.x += x_angle
						MoveDirection.Yaxis:
							movement = ObjectEditCursor.rotate_vector_around_point(movement, position, y_angle, Vector3.UP)
							rotations.y += y_angle
						MoveDirection.Zaxis:
							movement = ObjectEditCursor.rotate_vector_around_point(movement, position, z_angle, Vector3.BACK)
							rotations.z += z_angle
					node.set_attribute("position", movement)

					if node.get_attribute("rotation") != null:
						node.set_attribute("rotation", node.get_attribute("rotation") + rotations)
		ToolType.ToolType.ScaleTool:
			var scaling = Vector3()
			match current_move_direction:
				MoveDirection.Xaxis:
					scaling.x += relative.x * SCALE_AMPLIFIER * z_negative * current_camera.position.distance_to(position)
				MoveDirection.Yaxis:
					scaling.y -= relative.y * SCALE_AMPLIFIER * current_camera.position.distance_to(position)
				MoveDirection.Zaxis:
					scaling.z -= relative.x * SCALE_AMPLIFIER * x_negative * current_camera.position.distance_to(position)
			for node in Editor.selected_nodes:
				if node.get_attribute("scale") != null:
					node.set_attribute("scale", node.get_attribute("scale") + scaling)
				if node.get_attribute("position") != null:
					var movement = node.get_attribute("position") as Vector3
					var rel_pos = movement - position
					node.set_attribute("position", node.get_attribute("position") + rel_pos * scaling)
	modified_object.emit()

func _hide_cursor():
	x_axis.visible = false
	y_axis.visible = false
	z_axis.visible = false

func _show_cursor():
	x_axis.visible = true
	y_axis.visible = true
	z_axis.visible = true

func handle_exit():
	is_moving = false
	current_move_direction = MoveDirection.None
	for node in Editor.selected_nodes:
		var new_state: ObjectState = ObjectState.new().setup_from_node(node)
		if not current_state or not new_state.is_equal_to(current_state):
			current_state = new_state
			user_interface.undo_list.push_front(current_state)

static func rotate_vector_around_point(point_to_rotate: Vector3, pivot_point: Vector3, angle: float, axis: Vector3 = Vector3.UP) -> Vector3:
	var angle_rad = deg_to_rad(angle)
	var pivot_transform = Transform3D(Basis(), pivot_point)
	pivot_transform = pivot_transform.rotated(axis, angle_rad)
	var pivot_radius = point_to_rotate - pivot_point
	var rotated_vector = pivot_transform.basis * pivot_radius
	var final_rotated_point = rotated_vector + pivot_point
	return final_rotated_point

static func scale_vector_from_point(pos: Vector3, pivot_point: Vector3, scale_factor: Vector3):
	var pivot_to_object = pos - pivot_point
	var scaled_vector = pivot_to_object * scale_factor
	var new_position = pos + scaled_vector
	return new_position

func _on_x_axis_area_mouse_entered():
	var x_mesh: CylinderMesh = x_axis_mesh.mesh
	var x_material: StandardMaterial3D = x_mesh.material
	x_material.emission = Color.PALE_VIOLET_RED

func _on_x_axis_area_mouse_exited():
	var x_mesh: CylinderMesh = x_axis_mesh.mesh
	var x_material: StandardMaterial3D = x_mesh.material
	x_material.emission = Color.RED


func _on_y_axis_area_mouse_entered():
	var y_mesh: CylinderMesh = y_axis_mesh.mesh
	var y_material: StandardMaterial3D = y_mesh.material
	y_material.emission = Color.PALE_GREEN

func _on_y_axis_area_mouse_exited():
	var y_mesh: CylinderMesh = y_axis_mesh.mesh
	var y_material: StandardMaterial3D = y_mesh.material
	y_material.emission = Color.GREEN


func _on_z_axis_area_mouse_entered():
	var z_mesh: CylinderMesh = z_axis_mesh.mesh
	var z_material: StandardMaterial3D = z_mesh.material
	z_material.emission = Color.PALE_TURQUOISE

func _on_z_axis_area_mouse_exited():
	var z_mesh: CylinderMesh = z_axis_mesh.mesh
	var z_material: StandardMaterial3D = z_mesh.material
	z_material.emission = Color.BLUE


func _on_x_axis_area_input_event(camera, event: InputEvent, _pos, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_released():
			handle_exit()
		elif event.button_index == MOUSE_BUTTON_LEFT:
			current_camera = camera
			current_move_direction = MoveDirection.Xaxis
			is_moving = true


func _on_y_axis_area_input_event(camera, event: InputEvent, _pos, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_released():
			handle_exit()
		elif event.button_index == MOUSE_BUTTON_LEFT:
			current_camera = camera
			current_move_direction = MoveDirection.Yaxis
			is_moving = true


func _on_z_axis_area_input_event(camera, event: InputEvent, _pos, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_released():
			handle_exit()
		elif event.button_index == MOUSE_BUTTON_LEFT:
			current_camera = camera
			current_move_direction = MoveDirection.Zaxis
			is_moving = true


func _input(event):
	if event is InputEventMouseButton:
		if event.is_released():
			handle_exit()
	if event is InputEventMouseMotion:
		if is_moving and current_move_direction != MoveDirection.None:
			handle_edit(event.relative)

func _on_node_update():
	on_nodes_update()

func _on_attribute_change(_node: Primitive, _attr: Attribute):
	on_nodes_update()
