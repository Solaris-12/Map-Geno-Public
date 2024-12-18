class_name InpectorInputStringOption extends InspectorInputBase

var options: Array[String]
@onready var option_value = $Layout/VBox/OptionValue
@onready var options_el: OptionButton = $Layout/VBox/Options

func set_label(txt: String):
	super.set_label(txt)
	match txt:
		"prefab_type":
			set_options(GameImports.game_prefabs)
		"item_type":
			set_options(GameImports.game_item_types)
		"room_type":
			set_options(GameImports.game_room_names)
		"door_type":
			set_options(GameImports.mapgeno_door_type)
		"role_type":
			set_options(GameImports.game_role_types)

func get_val():
	return option_value.text

func set_val(val):
	option_value.text = str(val)

func set_options(o):
	for index in options_el.item_count:
		options_el.remove_item(index)

	for item in o:
		options_el.add_item(item)
	options_el.select(-1)

func _on_options_item_selected(index):
	set_val(options_el.get_item_text(index))
	options_el.select(-1)
	update.emit()

func _on_option_value_text_changed(_t):
	update.emit()
