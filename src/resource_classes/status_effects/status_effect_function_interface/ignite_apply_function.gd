tool
extends StatusEffectFunctionBase
class_name IgniteApplyFunction
func get_base(): return "StatusEffectFunctionBase"
func get_class(): return "IgniteApplyFunction"
func is_class(_class_name): return _class_name == get_class() or .is_class(_class_name)
func _to_string(): return "[%s :: %s]" % [get_class(), resource_path]
"""
	Ignites stack seperately and every tick strongest k {default:3}
	ignite damages the carrier.
	For the other effects that uses ignite stack on unit all stacks counted {not k}.
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

	status_dict[type].append(_status_effect)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
