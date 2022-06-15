extends PanelContainer
"""
"""

### SIGNAL ###
signal material_selected(mat)

### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
var _mat
var _ct

### ONREADY VAR ###
onready var countText 	= $HBoxContainer/MaterialCount as Label
onready var effectText	= $HBoxContainer/MaterialEffect as Label
onready var matTexture	= $HBoxContainer/TextureRect as TextureRect

### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func set_mat(mat : MaterialData, ct : int, mat_effect_on_weapon : String):
	_mat = mat
	_ct = ct

	effectText.text = mat_effect_on_weapon
	matTexture.texture = mat.sprite
	_update_visual()


func set_count(ct : int) -> void:
	_ct = ct
	_update_visual()

### PRIVATE FUNCTIONS ###
func _update_visual() -> void:
	assert(_mat)
	countText.text = str(_ct)


### SIGNAL RESPONSES ###
func _on_TextureButton_pressed() -> void:
	emit_signal("material_selected", _mat)
