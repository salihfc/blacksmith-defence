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
onready var bar = $ProgressBar as ProgressBar
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func set_value(value : float) -> void:
	bar.value = value * 100.0
### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
