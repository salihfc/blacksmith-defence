extends Node2D

"""

"""

### SIGNAL ###
signal floating_text_created(f_text)
### ENUM ###
### CONST ###
### EXPORT ###
export(PackedScene) var Prefab_FloatingText
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	assert(Prefab_FloatingText != null)

### PUBLIC FUNCTIONS ###
func generate(global_pos : Vector2, text : String):
	var floating_text = Prefab_FloatingText.instance()
	emit_signal("floating_text_created", floating_text)
	return floating_text.init(global_pos, text)


### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
