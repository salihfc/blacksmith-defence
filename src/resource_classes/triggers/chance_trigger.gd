extends Trigger
class_name ChanceTrigger
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
var _trigger_chance : float

### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _init(copied_effect = null, _args = {}) -> void:
	_effect = copied_effect
	_trigger_chance = _args.get('chance', 0.0)

### PUBLIC FUNCTIONS ###
func execute(_subject=null, _object=null, _args={}) -> void:
	LOG.pr(LOG.LOG_TYPE.INTERNAL, "[Trigger] [%s]" % [resource_name])
	if UTILS.check(_trigger_chance):
		if _object and _object is Unit:
			_object.apply_status_effect(_effect)


### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###

