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
onready var blacksmith = $PanelContainer/HBoxContainer/Blacksmith
onready var battle = $PanelContainer/HBoxContainer/Battle


### VIRTUAL FUNCTIONS (_init ...) ###
func _ready():
	UTILS.bind(
		blacksmith, "item_ready",
		battle, "_on_item_created"
	)

### PUBLIC FUNCTIONS ###


### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###
