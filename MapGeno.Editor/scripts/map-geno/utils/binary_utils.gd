class_name BinaryUtils extends Node

static func reverse_string(input: String) -> String:
	var reversed = ""
	for i in range(input.length() - 1, -1, -1):
		reversed += input[i]
	return reversed

static func binary_to_int(input: String) -> int:
	var output = 0
	var length = input.length()

	for i in range(length):
		var char = input[length - 1 - i] 
		if char == "1":
			output += 2 ** i  
	return output

static func int_to_binary(value: int) -> String:
	if value == 0:
		return "0"
	var binary = ""
	var number = value
	while number > 0:
		binary += str(number % 2)
		number = number / 2
	return reverse_string(binary)
