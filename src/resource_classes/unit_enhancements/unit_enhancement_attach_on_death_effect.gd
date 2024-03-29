extends UnitEnhancementBase
class_name UnitEnhancementAttachOnDeathEffect
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(Resource) var on_death_effect_prototype = null

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func apply_to(_unit) -> void:
	# Try to use the single instance tres
	# Since the tres will not be modified by any operation everybody can use it
	# knowing its correct
	_unit.add_on_death_trigger(
			Trigger.new(on_death_effect_prototype))

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###

