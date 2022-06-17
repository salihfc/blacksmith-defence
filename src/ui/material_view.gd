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
onready var texture = $HBoxContainer/TextureRect as TextureRect
onready var label = $HBoxContainer/Label as Label

### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func set_data(mat : MaterialData, count : int) -> void:
	texture.texture = mat.sprite
	label.text = str(count)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
