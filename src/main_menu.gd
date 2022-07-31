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
onready var creditsButton = $MarginContainerLeft/VBoxContainer/TitleContainerDown/VBoxContainer/MarginContainer3/CreditsButton

### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	GROUP.get_global(GROUP.SCENE_MANAGER).scene_loaded()
	creditsButton.visible = CONFIG.CREDITS_ON

### PUBLIC FUNCTIONS ###
### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###



func _on_PlayButton_pressed() -> void:
	var scene_manager = GROUP.get_global(GROUP.SCENE_MANAGER)
	if not scene_manager.is_loading():
		scene_manager.change_scene(scene_manager.SCENE.GAME_3)


func _on_SettingsButton_pressed() -> void:
	var scene_manager = GROUP.get_global(GROUP.SCENE_MANAGER)
	if not scene_manager.is_loading():
		scene_manager.change_scene(scene_manager.SCENE.SETTINGS)


func _on_HowToButton_pressed() -> void:
	var scene_manager = GROUP.get_global(GROUP.SCENE_MANAGER)
	if not scene_manager.is_loading():
		scene_manager.change_scene(scene_manager.SCENE.HOWTO)



func _on_CreditsButton_pressed() -> void:
	var scene_manager = GROUP.get_global(GROUP.SCENE_MANAGER)
	if not scene_manager.is_loading():
		scene_manager.change_scene(scene_manager.SCENE.CREDITS)
