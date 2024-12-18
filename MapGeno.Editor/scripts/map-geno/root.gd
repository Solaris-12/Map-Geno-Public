class_name Root extends Node3D

static var SingleTon: Root
static var Camera: FreeLookCamera
static var ObjectHolder: Node3D
static var WorldHolder: Node3D
static var Cursor: ObjectEditCursor

func _ready():
	SingleTon = self
	Camera = $Camera3D
	ObjectHolder = $ObjectHolder
	WorldHolder = $WorldHolder
	Cursor = $ProgramManager/CursorLayer/ObjectEditCursor
