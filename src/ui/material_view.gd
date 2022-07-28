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
func set_data(mat : int, count : int):
	texture.texture = MAT.get_texture(mat)
	label.text = str(count)
	return self

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
