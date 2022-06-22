extends Node
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
var _data = {}

### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	LOG.pr(3, "TIMER_ALLOCATOR READY")

### PUBLIC FUNCTIONS ###
func alloc(object : Object, method : String, duration : float, one_shot = true):
	var timer = Timer.new()
	timer.one_shot = one_shot
	timer.connect("timeout", object, method, [timer])
	timer.connect("tree_exiting", self, "_on_timer_retiring", [timer, object, method, duration])

	if not timer in _data:
		_data[timer] = []
	_data[timer].append([object, method, duration])

	add_child(timer)
	timer.start(duration)

	return timer


func retire(timer) -> void:
	timer.queue_free()

### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_timer_retiring(timer, object, method, duration):
	_data.erase(timer)
