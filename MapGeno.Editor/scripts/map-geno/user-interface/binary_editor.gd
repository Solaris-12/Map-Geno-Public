class_name BinaryEditor extends CanvasLayer

signal update(val: int)

static var SingleTon: BinaryEditor
static var CurrentInput: LineEdit

@onready var content_holder = $Wrapper/Panel/Layout/ScrollContainer/ContentHolder
@onready var line_edit = $Wrapper/Panel/Layout/LineEdit

var buttons = []
var values = {
	"Keycard Permissions": GameImports.keycard_permissions,
	"Door Lock Type": GameImports.door_lock_type,
}

func _ready():
	BinaryEditor.SingleTon = self
	for key in values.keys():
		var value = values[key]
		var value_label = Label.new()
		value_label.text = key
		
		var option_holder = GridContainer.new()
		option_holder.columns = 2
		for option in value.keys():
			var option_button = Button.new()
			option_button.text = option + " " + str(value[option])
			option_button.custom_minimum_size = Vector2(275, 20)
			option_button.add_theme_font_size_override("font_size", 12)
			option_button.pressed.connect(_handle_button_select.bind(value[option]))
			option_holder.add_child(option_button)
			buttons.push_back(option_button)
		content_holder.add_child(value_label)
		content_holder.add_child(option_holder)

static func open(textInput: LineEdit = null):
	SingleTon.show()
	SingleTon.line_edit.text = "00000000000000000000"
	CurrentInput = textInput
	if textInput != null:
		var text = textInput.text
		SingleTon.line_edit.text = text if len(text) >= 20 else "0000000000000" + BinaryUtils.int_to_binary(int(textInput.text))
	BinaryEditor.reload_buttons()

static func reload_buttons():
	for button: Button in SingleTon.buttons:
		var value := button.text.split(" ")[-1]
		var index: int = SingleTon.line_edit.text.length() - len(value)
		if index > 0 and SingleTon.line_edit.text[index] == "1":
			button.add_theme_color_override("font_color", Color.from_string("#97EB79", Color.PALE_GREEN))
		else:
			button.remove_theme_color_override("font_color")

func _handle_button_select(val: int):
	var currentBin = line_edit.text
	var newVal = str(val)
	var index_from_end = len(newVal) - 1
	
	if index_from_end < 0 or index_from_end >= currentBin.length():
		print("Index out of bounds")
		return
	
	var actual_index = currentBin.length() - 1 - index_from_end
	var current_char = currentBin[actual_index]
	var new_char = '0' if current_char == '1' else '1'
	var new_bin = currentBin.substr(0, actual_index) + new_char + currentBin.substr(actual_index + 1)
	line_edit.text = new_bin
	BinaryEditor.reload_buttons()

func _on_line_edit_text_changed(_t):
	InputUtils.parse_binary(line_edit)

func _on_close_button_pressed():
	SingleTon.hide()


func _on_confirm_button_pressed():
	var output = BinaryUtils.binary_to_int(line_edit.text)
	if CurrentInput != null:
		CurrentInput.text = str(output)
		CurrentInput.text_changed.emit(null)
	self.update.emit(output)
	self._on_close_button_pressed()
