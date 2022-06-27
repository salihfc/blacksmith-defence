extends OnHitEffect
class_name OnHitApplyStatus
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(Resource) var status_effect
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _init(_status_effect) -> void:
	status_effect = _status_effect


func copy_from_prototype(_prototype):
	status_effect = StatusEffect.new().clone_from_prototype(_prototype)
	return self

### PUBLIC FUNCTIONS ###
func trigger(_subject=null, _object=null, _args={}):
	LOG.pr(LOG.LOG_TYPE.INTERNAL, "OnHitApplyStatus > working")
	_object.apply_status_effect(
			status_effect.set_originator(
				_args.get('damage')
			)
	)


### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###

