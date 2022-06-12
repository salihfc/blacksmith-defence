extends Sprite

"""

"""

### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(Color) var valid_placement_color = Color("416de42b")
export(Color) var invalid_placement_color = Color("41e42b38")
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func set_texture(tex : Texture) -> void:
	texture = tex
	offset.y = -texture.get_height() / 2.0


func set_valid(valid := true) -> void:
	if valid:
		modulate = valid_placement_color
	else:
		modulate = invalid_placement_color

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
