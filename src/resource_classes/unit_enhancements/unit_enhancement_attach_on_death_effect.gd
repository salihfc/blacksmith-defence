extends UnitEnhancementBase
class_name UnitEnhancementAttachOnDeathEffect
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
export(Resource) var on_death_effect_prototype = null

### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func apply_to(_unit) -> void:
	_unit.add_on_death_trigger(
		OnDeathTrigger.new(
			# Try to use the single instance tres
			# Since the tres will not be modified by any operation everybody can use it
			# knowing its correct
			on_death_effect_prototype
		)
	)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###

