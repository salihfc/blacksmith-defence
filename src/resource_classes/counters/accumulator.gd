extends Resource
class_name Accumulator
"""
"""
### SIGNAL ###
signal limit_reached()

### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
var _accumulated : float
var _threshold : float

### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _init(threshold : float) -> void:
	_accumulated = 0.0
	_threshold = threshold

### PUBLIC FUNCTIONS ###
func add(x : float):
	_accumulated += x
	_on_change()
	return self


func clear():
	_accumulated = 0.0
	_on_change()
	return self


func get_threshold():
	return _threshold


### PRIVATE FUNCTIONS ###
func _on_change():
	if _accumulated >= _threshold:
		emit_signal("limit_reached")
	return self

### SIGNAL RESPONSES ###

