tool
extends Resource
class_name IAUSObject
func get_base(): return "Resource"
func get_class(): return "IAUSObject"
func is_class(_name): return _name == "IAUSObject" or .is_class(_name)
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
func _init():
	resource_local_to_scene = true
### PUBLIC FUNCTIONS ###
### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
