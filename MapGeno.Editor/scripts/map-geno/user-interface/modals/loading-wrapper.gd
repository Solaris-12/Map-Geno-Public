class_name LoadingWrapper extends Control

signal loadingUpdate()

static var SingleTon: LoadingWrapper

@onready var loading_wrapper = $"."
@onready var loading_status_label = $LoadingPanel/LoadingLayout/LoadingStatusLabel
@onready var loading_progress_bar = $LoadingPanel/LoadingLayout/LoadingProgressBar

func _ready():
	SingleTon = self

static func update_loading(at: float, from: float, msg = "LOADING: \n"):
	SingleTon.loading_wrapper.visible = true
	
	if (at + 1 >= from):
		SingleTon.loading_wrapper.visible = false
		return
		
	SingleTon.loading_status_label.text = msg+str(at)+"/"+str(from)
	SingleTon.loading_progress_bar.value = (float(at) / float(from)) * 100
	
	SingleTon.call_deferred("emit_update")

func emit_update():
	loadingUpdate.emit()
