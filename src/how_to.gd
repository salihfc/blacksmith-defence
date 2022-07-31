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
onready var tabs = $TabContainer

### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	GROUP.get_global(GROUP.SCENE_MANAGER).scene_loaded()

### PUBLIC FUNCTIONS ###
### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
func _on_Button_pressed() -> void:
	var scene_manager = GROUP.get_global(GROUP.SCENE_MANAGER)
	if not scene_manager.is_loading():
		scene_manager.change_scene(scene_manager.SCENE.MAIN_MENU)


func _on_NextButton_pressed() -> void:
	tabs.current_tab = (tabs.current_tab + 1) % (tabs.get_tab_count())
