class_name ToolWrapper extends Control

@onready var cursor_tool_button = $EditorToolLayout/ToolsContainer/CursorToolButton
@onready var move_tool_button = $EditorToolLayout/ToolsContainer/MoveToolButton
@onready var rotate_tool_button = $EditorToolLayout/ToolsContainer/RotateToolButton
@onready var scale_tool_button = $EditorToolLayout/ToolsContainer/ScaleToolButton
@onready var tool_buttons = [cursor_tool_button, move_tool_button, rotate_tool_button, scale_tool_button]

func _on_editor_tool_change(_tool):
	for button in tool_buttons:
		button.release_focus()
		button.remove_theme_color_override("icon_normal_color")
	
	match Editor.current_tool:
		ToolType.ToolType.CursorTool:
			cursor_tool_button.add_theme_color_override("icon_normal_color", Color.from_string("#97EB79", Color.PALE_GREEN))
		ToolType.ToolType.MoveTool:
			move_tool_button.add_theme_color_override("icon_normal_color", Color.from_string("#97EB79", Color.PALE_GREEN))
		ToolType.ToolType.RotateTool:
			rotate_tool_button.add_theme_color_override("icon_normal_color", Color.from_string("#97EB79", Color.PALE_GREEN))
		ToolType.ToolType.ScaleTool:
			scale_tool_button.add_theme_color_override("icon_normal_color", Color.from_string("#97EB79", Color.PALE_GREEN))


func _on_cursor_tool_button_pressed():
	Editor.select_tool(ToolType.ToolType.CursorTool)

func _on_move_tool_button_pressed():
	Editor.select_tool(ToolType.ToolType.MoveTool)

func _on_rotate_tool_button_pressed():
	Editor.select_tool(ToolType.ToolType.RotateTool)

func _on_scale_tool_button_pressed():
	Editor.select_tool(ToolType.ToolType.ScaleTool)
