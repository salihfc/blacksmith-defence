tool
extends OnHitEffect
class_name OnHitApplyStatus
func get_base(): return "OnHitEffect"
func get_class(): return "OnHitApplyStatus"
func is_class(_class_name): return _class_name == get_class() or .is_class(_class_name)
func _to_string(): return "[%s :: %s]" % [get_class(), resource_path]
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(Resource) var status_effect_prototype
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _init(_status_effect_prototype) -> void:
	status_effect_prototype = _status_effect_prototype


func copy_from_prototype(_prototype):
	status_effect_prototype = _prototype
	return self

### PUBLIC FUNCTIONS ###
func trigger(_subject=null, _object=null, _args={}):
	# Making sure target object still exist to prevent segfault
	if _object == null or not is_instance_valid(_object) or _object.is_queued_for_deletion():
		return

	LOG.pr(LOG.LOG_TYPE.INTERNAL, "OnHitApplyStatus > working")

	"""
		NOTE: carefull in the future
			* Always clone the resource while applying it, cloning only in initialization is not enough
	"""

	_object.apply_status_effect(
			StatusEffect.new().clone_from_prototype(status_effect_prototype).set_originator(
				_args.get('damage')
			)
	)


### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###

