tool
extends IAUSObject
class_name Action
func get_base(): return "IAUSObject"
func get_class(): return "Action"
func is_class(_name): return _name == "Action" or .is_class(_name)
"""
"""

### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(Array, Resource) var _considerations = []
export(IAUS.ACTION) var action_type = IAUS.ACTION.IDLE

### PUBLIC VAR ###
var target = null
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func score(context, actor, _target = null, base : float = 1.0) -> float:
	for axis in _considerations:
		var axis_score = axis.utility(context, actor, _target)
		base *= axis_score

	# normalization
	return pow(base, 1.0/_considerations.size())


### PRIVATE FUNCTIONS ###
func _to_string():
	return resource_path.get_file()

### SIGNAL RESPONSES ###
