tool
extends StatusEffectFunctionBase
class_name StatusEffectGenericExpire
func get_base(): return "StatusEffectFunctionBase"
func get_class(): return "StatusEffectGenericExpire"
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
	var type = _status_effect.get_type()
	var status_dict = _container.get_dict()
	if type in status_dict:
		status_dict[type].erase(_status_effect)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
