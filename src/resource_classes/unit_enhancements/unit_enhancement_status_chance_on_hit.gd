extends UnitEnhancementBase
class_name UnitEnhancementStatusChanceOnHit
"""
"""

### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
var _apply_chance
var _status_effect

### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _init(apply_chance = 0.0, status_effect = null) -> void:
	_apply_chance = apply_chance
	_status_effect = status_effect

### PUBLIC FUNCTIONS ###
func apply_to(_unit) -> void:
	_unit.add_on_hit_trigger(
		OnHitStatusEffect.new(
			_apply_chance,
			_status_effect
		)
	)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
