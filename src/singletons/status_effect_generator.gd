extends Node
"""
"""

### SIGNAL ###
### ENUM ###
### CONST ###
const STATUS_EFFECT_PROTOTYPES = {
	StatusEffect.TYPE.POISON : preload("res://tres/status_effects/status_effect_poison.tres"),
}

### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func create_status(type, duration, value):
	assert(STATUS_EFFECT_PROTOTYPES.get(type))

	return StatusEffect.new()\
			.clone_from_prototype(STATUS_EFFECT_PROTOTYPES[type])\
			.set_duration(duration)\
			.set_value(value)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
