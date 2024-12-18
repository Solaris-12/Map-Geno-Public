class_name JsonUtils

static func vector3_to_dict(v: Vector3) -> Dictionary:
	return {
		"x": v.x,
		"y": v.y,
		"z": v.z
	}

static func color_to_dict(c: Color) -> Dictionary:
	return {
		"r": c.r,
		"g": c.g,
		"b": c.b,
		"a": c.a
	}

static func vector3_from_dict(input: Dictionary) -> Vector3:
	return Vector3(input["x"], input["y"], input["z"])

static func color_from_dict(input: Dictionary) -> Color:
	if input.has("a"):
		return Color(input["r"], input["g"], input["b"], input["a"])
	return Color(input["r"], input["g"], input["b"])
