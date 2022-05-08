extends Sprite

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
func set_texture(tex : Texture) -> void:
	texture = tex
	offset.y = -texture.get_height() / 2.0

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
