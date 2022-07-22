tool
extends StatusEffectFunctionBase
class_name IgniteTickFunction
func get_base(): return "StatusEffectFunctionBase"
func get_class(): return "IgniteTickFunction"
func is_class(_class_name): return _class_name == get_class() or .is_class(_class_name)
func _to_string(): return "[%s :: %s]" % [get_class(), resource_path]
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
const IGNITE_DAMAGE_TYPE = Damage.TYPE.FIRE

### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func execute(_status_effect : StatusEffect, _container, _carrier_unit : Unit) -> void:
	# Delete function to avoid Abstract class call
	if _status_effect.get_duration() > 0.0:
		# Duration is the stack count for poison
		var total_damage = _calc_damage(_status_effect, _container, _carrier_unit)
		_carrier_unit.take_damage(total_damage.set_originator(_status_effect.get_originator()))

		LOG.pr(LOG.LOG_TYPE.GAMEPLAY, "[%s] taking [%s] damage from poison" % [
			_carrier_unit,
			total_damage
		])

	_status_effect.set_duration(_status_effect.get_duration() - 1)


func get_damage(_status_effect : StatusEffect, _container, _carrier_unit : Unit):
	return _calc_damage(_status_effect, _container, _carrier_unit)

### PRIVATE FUNCTIONS ###
func _calc_damage(_status_effect : StatusEffect, _container, _carrier_unit : Unit):
	var originator = _status_effect.get_originator() # Damage

	return Damage.new(
		IGNITE_DAMAGE_TYPE,
		FORMULA.get_ignite_damage(originator)
	)

### SIGNAL RESPONSES ###
