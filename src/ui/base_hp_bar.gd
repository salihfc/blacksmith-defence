extends PanelContainer

"""

"""

### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
onready var textureProgress = $TextureProgress as TextureProgress
### VIRTUAL FUNCTIONS (_init ...) ###
func _ready():
	set_hp_value(1, 1)

### PUBLIC FUNCTIONS ###
func set_hp_value(cur_hp, max_hp) -> void:
	textureProgress.value = (cur_hp / max_hp) * 100.0


### PRIVATE FUNCTIONS ###

### SIGNAL RESPONSES ###
