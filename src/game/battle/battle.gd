extends Panel

"""

"""

### SIGNAL ###
signal player_defeated()

### ENUM ###


### CONST ###


### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###
onready var battleWorld = $ViewportContainer/Viewport/BattleWorld as Node2D


### VIRTUAL FUNCTIONS (_init ...) ###
func _ready():
	UTILS.bind(
		battleWorld, "player_base_destroyed",
		self, "_on_player_base_destroyed"
	)


### PUBLIC FUNCTIONS ###



### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###



func _on_player_base_destroyed() -> void:
	emit_signal("player_defeated")
