extends Resource
class_name StatusEffectContainer
"""
"""

### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(float) var tick_period = 0.5 # default is 0.5 seconds

### PUBLIC VAR ###
### PRIVATE VAR ###
var _statuses = {
	# 'type' : Array of instances
}

var _owner_weakref = null

### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func start(owner_ref):
	_owner_weakref = weakref(owner_ref)
	TIMER_ALLOC.alloc(
		self, "tick",
		tick_period, false
	)

	return self


func tick(_timer) -> void:
	for status_type in _statuses:
		for status in _statuses[status_type]:
			status.tick(self, get_owner())
			if status.get_duration() <= 0.0:
				status.expire(self, get_owner())


func add_status(status): # This should get already cloned res so no need to duplicate
	SIGNAL.bind(
		status, "expired",
		self, "_on_status_expired",
		[status]
	)

	status.apply(self, get_owner())
	return self


func get_dict():
	return _statuses


func get_owner():
	if _owner_weakref:
		return _owner_weakref.get_ref()

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
func _on_status_expired(status) -> void:
	_statuses.erase(status)
