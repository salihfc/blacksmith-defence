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
		# FIXME: For now handling of different type of StatusEffect s handled here with switch/case
		match status_type:
			StatusEffect.TYPE.IGNITE: # Ignites handled differently here
				var IGNITE_DAMAGE_INSTANCE_COUNT = 3
				# Select 3 ignites with highest damage
				# Only let them tick with damage
				# Tick others without activating
				var ignites = _statuses[status_type] as Array
				var ignite_damage_pairs = []

				for ignite in ignites:
					ignite_damage_pairs.append([ignite, ignite.get_tick_damage(self, get_owner())])

				ignite_damage_pairs.sort_custom(FORMULA.SortPairsBySecondElement, "sort_descending")

				for idx in min(IGNITE_DAMAGE_INSTANCE_COUNT, ignite_damage_pairs.size()):
					var ignite = ignite_damage_pairs[idx][0]
					ignite.tick(self, get_owner())
					if ignite.get_duration() <= 0.0:
						ignite.expire(self, get_owner())

			_: # All remaning handled here with default behaviour
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
