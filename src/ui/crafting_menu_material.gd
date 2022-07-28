extends MarginContainer
#extends PanelContainer
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
onready var countText 	= $PanelContainer/HBoxContainer/MaterialCount as Label
onready var effectText	= $PanelContainer/HBoxContainer/MaterialEffect as Label
onready var matTexture	= $PanelContainer/HBoxContainer/TextureRect as TextureRect
onready var textureButton = $PanelContainer/TextureButton as TextureButton

### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	SIGNAL.bind(
		textureButton, "pressed",
		self, "_on_TextureButton_pressed"
	)

### PUBLIC FUNCTIONS ###
func set_mat(mat : int, ct : int, mat_effect_on_weapon : String):
	_mat = mat
	_ct = ct

	effectText.text = mat_effect_on_weapon
	matTexture.texture = MAT.get_texture(mat)
	_update_visual()


func set_count(ct : int) -> void:
	_ct = ct
	_update_visual()

### PRIVATE FUNCTIONS ###
func _update_visual() -> void:
	assert(_mat != null)
	countText.text = str(_ct)


### SIGNAL RESPONSES ###
func _on_TextureButton_pressed() -> void:
	emit_signal("material_selected", _mat)
