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
var _status_effect_prototype

### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _init(apply_chance = 0.0, status_effect = null) -> void:
	_apply_chance = apply_chance
	_status_effect_prototype = status_effect

### PUBLIC FUNCTIONS ###
func apply_to(_unit) -> void:
	_unit.add_on_hit_trigger(
		ChanceTrigger.new(
			OnHitApplyStatus.new(StatusEffect.new().clone_from_prototype(_status_effect_prototype)),
			{'chance' : _apply_chance}
		)
	)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
