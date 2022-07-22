tool
extends Effect
class_name OnLowLifeEffect
func get_base(): return "Effect"
func get_class(): return "OnLowLifeEffect"
func is_class(_class_name): return _class_name == get_class() or .is_class(_class_name)
func _to_string(): return "[%s :: %s]" % [get_class(), resource_path]
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
### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###

