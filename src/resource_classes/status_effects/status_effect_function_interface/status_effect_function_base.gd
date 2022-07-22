tool
extends Resource
class_name StatusEffectFunctionBase
func get_base(): return "Resource"
func get_class(): return "StatusEffectFunctionBase"
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
### PUBLIC FUNCTIONS ###
func execute(_status_effect : StatusEffect, _container, _carrier_unit : Unit) -> void:
	# Delete function to avoid Abstract class call
	assert(0)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
