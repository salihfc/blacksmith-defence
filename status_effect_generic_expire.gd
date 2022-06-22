extends StatusEffectFunctionBase
class_name StatusEffectGenericExpire
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
