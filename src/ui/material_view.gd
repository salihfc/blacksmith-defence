extends Control
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
var _mat
var _count

### ONREADY VAR ###
onready var texture = $HBoxContainer/TextureRect as TextureRect
onready var label = $HBoxContainer/Label as Label

### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	assert(_mat != null and _count != null)

	texture.texture = MAT.get_texture(_mat)
	label.text = str(_count)

### PUBLIC FUNCTIONS ###
func set_data(mat : int, count : int):
	_mat = mat
	_count = count
	return self

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
