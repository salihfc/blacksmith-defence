extends Control
class_name WaveCounter
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
func _ready() -> void:
	set_value(0)

### PUBLIC FUNCTIONS ###
func set_value(wave : int):
	$HBoxContainer/CountLabel.text = str(wave)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###

