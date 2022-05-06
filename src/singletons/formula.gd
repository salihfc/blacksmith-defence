extends Node

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
func get_resisted(value : float, resist : float):
	return value * (1.0 - (resist/100.0))

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
