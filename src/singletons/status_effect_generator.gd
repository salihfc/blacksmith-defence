tool
extends Node
"""
"""

### SIGNAL ###
### ENUM ###
### CONST ###
const STATUS_EFFECT_PROTOTYPES = {
	StatusEffect.TYPE.POISON : preload("res://tres/status_effects/status_effect_poison.tres"),
	StatusEffect.TYPE.BLEED : preload("res://tres/status_effects/status_effect_bleed.tres"),
	StatusEffect.TYPE.IGNITE : preload("res://tres/status_effects/status_effect_ignite.tres"),
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
			.set_value(value)\
			.report()

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
