extends Resource
class_name Trigger
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
var _effect

### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _init(copied_effect = null, _args = {}) -> void:
	_effect = copied_effect

### PUBLIC FUNCTIONS ###
func execute(_subject=null, _object=null, _args={}) -> void:
	LOG.pr(LOG.LOG_TYPE.INTERNAL, "[Trigger] [%s]" % [resource_name])
	_effect.trigger(_subject)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###

