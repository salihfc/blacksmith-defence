extends Control
class_name ModDisplay
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
onready var textureRect = $TextureRect as TextureRect

### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func set_icon(icon) -> void:
	if icon:
		textureRect.texture = icon

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###

