extends OnHitTrigger
class_name OnHitStatusEffect
"""
"""

### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
var _status_effect
var _apply_chance

### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _init(apply_chance, status_effect) -> void:
	_apply_chance = apply_chance
	_status_effect = status_effect

### PUBLIC FUNCTIONS ###
func apply_to(_target, _damage) -> void:
	if UTILS.check(_apply_chance):
		_status_effect.apply(_target.get_status_effect_container(), _target)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
