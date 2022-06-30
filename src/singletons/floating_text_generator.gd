extends Node2D
"""
"""
### SIGNAL ###
signal floating_text_created(f_text)

### ENUM ###
### CONST ###
### EXPORT ###
export(PackedScene) var P_FloatingText

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	assert(P_FloatingText != null) # +

### PUBLIC FUNCTIONS ###
func generate(global_pos : Vector2, text : String):
	var floating_text = P_FloatingText.instance()
#	emit_signal("floating_text_created", floating_text)
	GROUP.get_global(GROUP.BATTLE_WORLD).floatingTextContainer.add_child(floating_text)

	return floating_text.init(global_pos, text)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
