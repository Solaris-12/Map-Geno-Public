class_name ObjectType extends Object

enum ObjectType {
	None = -1,
	Cube = 0,
	Sphere = 1,
	Capsule = 2,
	Cylinder = 3,
	Plane = 4,
	Light = 5,
	Prefab = 6,
	ItemSpawn = 7,
	SpawnPoint = 8,
	Door = 9,

	Group = 20,
	TemplateImage = 21
}

static func translate(type: ObjectType.ObjectType) -> String:
	match type:
		ObjectType.ObjectType.None:
			return "None"
		ObjectType.ObjectType.Cube:
			return "Cube"
		ObjectType.ObjectType.Sphere:
			return "Sphere"
		ObjectType.ObjectType.Capsule:
			return "Capsule"
		ObjectType.ObjectType.Cylinder:
			return "Cylinder"
		ObjectType.ObjectType.Plane:
			return "Plane"
		ObjectType.ObjectType.Light:
			return "Light"
		ObjectType.ObjectType.Prefab:
			return "Prefab"
		ObjectType.ObjectType.ItemSpawn:
			return "Item Spawner"
		ObjectType.ObjectType.SpawnPoint:
			return "Spawn Point"
		ObjectType.ObjectType.Door:
			return "Door"
		ObjectType.ObjectType.Group:
			return "Group"
		ObjectType.ObjectType.TemplateImage:
			return "Template Image"
	return "Unknown"

static func to_int(obt: ObjectType) -> int:
	match obt:
		ObjectType.ObjectType.Cube:
			return 0
		ObjectType.ObjectType.Sphere:
			return 1
		ObjectType.ObjectType.Capsule:
			return 2
		ObjectType.ObjectType.Cylinder:
			return 3
		ObjectType.ObjectType.Plane:
			return 4
		ObjectType.ObjectType.Light:
			return 5
		ObjectType.ObjectType.Prefab:
			return 6
		ObjectType.ObjectType.ItemSpawn:
			return 7
		ObjectType.ObjectType.SpawnPoint:
			return 8
		ObjectType.ObjectType.Door:
			return 9
		ObjectType.ObjectType.Group:
			return 20
		ObjectType.ObjectType.TemplateImage:
			return 21
	return -1

static func from_int(input) -> ObjectType.ObjectType:
	match int(input):
		0:
			return ObjectType.ObjectType.Cube
		1:
			return ObjectType.ObjectType.Sphere
		2:
			return ObjectType.ObjectType.Capsule
		3:
			return ObjectType.ObjectType.Cylinder
		4:
			return ObjectType.ObjectType.Plane
		5:
			return ObjectType.ObjectType.Light
		6:
			return ObjectType.ObjectType.Prefab
		7:
			return ObjectType.ObjectType.ItemSpawn
		8:
			return ObjectType.ObjectType.SpawnPoint
		9:
			return ObjectType.ObjectType.Door
		20:
			return ObjectType.ObjectType.Group
		21:
			return ObjectType.ObjectType.TemplateImage
		_:
			return ObjectType.ObjectType.None
