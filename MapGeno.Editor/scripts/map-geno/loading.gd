class_name Starter extends Node

static var SingleTon: Starter

func _init():
	Starter.SingleTon = self
	Settings.setup_settings()

func _ready():
	get_tree().call_deferred("change_scene_to_file", "res://scenes/main.tscn")
