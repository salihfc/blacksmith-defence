extends Node


func _ready() -> void:
	LOG.pr(3, "READY", "CONFIG")
	OS.center_window()
	Engine.target_fps = 60


func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE) and OS.is_debug_build():
		get_tree().quit()
