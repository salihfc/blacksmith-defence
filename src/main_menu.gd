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
	GROUP.get_global(GROUP.SCENE_MANAGER).change_scene(SceneManager.BATTLE_WORLD)
