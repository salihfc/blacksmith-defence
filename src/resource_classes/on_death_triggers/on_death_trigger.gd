extends Resource
class_name OnDeathTrigger
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
var _on_death_effect

### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _init(copied_effect = null) -> void:
	_on_death_effect = copied_effect

### PUBLIC FUNCTIONS ###
func trigger(_subject) -> void:
	LOG.pr(LOG.LOG_TYPE.INTERNAL, "OnDeathTrigger > working")
	assert(_on_death_effect)
	_on_death_effect.trigger(_subject)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
