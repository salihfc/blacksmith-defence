extends Control
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###



func _on_PlayButton_pressed() -> void:
	var scene_manager = GROUP.get_global(GROUP.SCENE_MANAGER)
	scene_manager.change_scene(scene_manager.SCENE.GAME_3)


func _on_SettingsButton_pressed() -> void:
	var scene_manager = GROUP.get_global(GROUP.SCENE_MANAGER)
	scene_manager.change_scene(scene_manager.SCENE.SETTINGS)
