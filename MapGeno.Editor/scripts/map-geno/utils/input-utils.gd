class_name InputUtils

static func parse_float(input: LineEdit) -> float:
	var cleaned_input = ""
	var starting_text = input.text
	for character in starting_text:
		if character in "0123456789.-":
			cleaned_input += character
	if starting_text != cleaned_input:
		input.text = cleaned_input
	return float(input.text)

static func parse_int(input: LineEdit) -> int:
	var cleaned_input = ""
	var starting_text = input.text
	for character in starting_text:
		if character in "0123456789-":
			cleaned_input += character
	if starting_text != cleaned_input:
		input.text = cleaned_input
	return int(input.text)

static func parse_binary(input: LineEdit) -> int:
	var cleaned_input = ""
	var starting_text = input.text
	for character in starting_text:
		if character in "01":
			cleaned_input += character
	if starting_text != cleaned_input:
		input.text = cleaned_input
	return int(input.text)

static func sanitize_string(input: String) -> String:
	var regex = RegEx.new()
	regex.compile("[^a-z0-9-]")
	return regex.sub(input.replace(" ", "-").to_lower(), "", true)

