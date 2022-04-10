extends Node

"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###
# POOL params
const STARTING_TWEEN_COUNT = 10
const POOL_SIZE_INCREASE_PERC = 0.9
const POOL_SIZE_INCREASE_FACTOR = 2

# TWEEN params
const DEFAULT_TRANSITION = Tween.TRANS_QUART
const DEFAULT_EASING = Tween.EASE_IN_OUT
const DEFAULT_DELAY = 0.0

### EXPORT ###


### PUBLIC VAR ###

### PRIVATE VAR ###


### ONREADY VAR ###
onready var active = $Active as Node
onready var passive = $Passive as Node



### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	_add_passive_workers(STARTING_TWEEN_COUNT)
	LOG.pr(3, "READY", "TWEEN")


### PUBLIC FUNCTIONS ###
func interpolate_property(
		object : Object, property : String,
		start_value, end_value,
		duration,
		transition = DEFAULT_TRANSITION,
		easing = DEFAULT_EASING,
		delay = DEFAULT_DELAY) -> void:
	
	var tween = _request_worker()
# warning-ignore:return_value_discarded
	tween.interpolate_property(
			object, property,
			start_value, end_value,
			duration,
			transition, easing,
			delay
	)
# warning-ignore:return_value_discarded
	tween.start()


func interpolate_method(
		object : Object, method : String,
		start_value, end_value,
		duration,
		transition = DEFAULT_TRANSITION,
		easing = DEFAULT_EASING,
		delay = DEFAULT_DELAY) -> void:
	
	var tween = _request_worker()
# warning-ignore:return_value_discarded
	tween.interpolate_method(
			object, method,
			start_value, end_value,
			duration,
			transition, easing,
			delay
	)
# warning-ignore:return_value_discarded
	tween.start()


func interpolate_method_to_and_back(
		object : Object, method : String,
		start_value, mid_value,
		part1_duration, part2_duration) -> void:
	
	var tween = _request_worker()
	
# warning-ignore:return_value_discarded
	tween.interpolate_method(
			object, method,
			start_value, mid_value,
			part1_duration, Tween.TRANS_QUART, Tween.EASE_IN_OUT
	)

# warning-ignore:return_value_discarded
	tween.interpolate_method(
			object, method,
			mid_value, start_value,
			part2_duration, Tween.TRANS_QUART, Tween.EASE_IN_OUT,
			part1_duration
	)

# warning-ignore:return_value_discarded
	tween.start()


### PRIVATE FUNCTIONS ###
func _add_passive_workers(count : int) -> void:
	for _i in count:
		var tween = Tween.new()
		tween.connect("tween_all_completed", self, "_on_tween_done", [tween])
		passive.add_child(tween)


func _pool_size() -> int:
	return active.get_child_count() + passive.get_child_count()


func _active_ratio() -> float:
	return (active.get_child_count()) / _pool_size()


func _pool_size_check() -> void:
	if _active_ratio() >= POOL_SIZE_INCREASE_PERC:
		_add_passive_workers(int(_pool_size() * POOL_SIZE_INCREASE_FACTOR + 0.5))


# Return activated worker
func _request_worker():
	_pool_size_check()

	var worker = passive.get_child(0)
	_activate_worker(worker)
	return worker


func _activate_worker(worker) -> void:
	passive.remove_child(worker)
	active.add_child(worker)


func _deactivate_worker(worker) -> void:
	active.remove_child(worker)
	passive.add_child(worker)


### SIGNAL RESPONSES ###

func _on_tween_done(tween : Tween) -> void:
	tween.remove_all()
	_deactivate_worker(tween)
