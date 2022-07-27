tool
extends StatusEffectFunctionBase
class_name BleedApplyFunction
func get_base(): return "StatusEffectFunctionBase"
func get_class(): return "BleedApplyFunction"
func is_class(_class_name): return _class_name == get_class() or .is_class(_class_name)
func _to_string(): return "[%s :: %s]" % [get_class(), resource_path]
"""
	Bleed stacks just like poison,
	the difference is that when new bleed applied duration resets to new bleeds duration.
	When duration reaches 0, All bleed expires
	{which is just one because new bleeds just transfer their stacks and duration}
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
		status_dict[type][0].set_value(status_dict[type][0].get_value() + _status_effect.get_value())
		status_dict[type][0].set_duration(_status_effect.get_duration())
	else:
		assert(0)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
