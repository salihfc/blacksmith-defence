extends StatusEffectFunctionBase
class_name PoisonApplyFunction
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
	var status_dict = _container.get_dict()
	var type = _status_effect.get_type()

	if not type in status_dict:
		status_dict[type] = []

	if status_dict[type].size() == 0:
		status_dict[type].append(_status_effect)
	elif status_dict[type].size() == 1:
		status_dict[type][0].set_duration(status_dict[type][0].get_duration() + _status_effect.get_duration())
	else:
		assert(0)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
