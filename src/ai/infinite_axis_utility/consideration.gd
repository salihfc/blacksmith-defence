extends IAUSObject
class_name Consideration
func get_base(): return "IAUSObject"
func get_class(): return "Consideration"
func is_class(_name): return _name == "Consideration" or .is_class(_name)
"""

"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(String) var name = "consideration"
export(Resource) var utility_curve = UtilityCurve.new()
export(IAUS.INPUT) var input_type = IAUS.INPUT.NONE

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _to_string():
	return name

### PUBLIC FUNCTIONS ###
func utility(context, actor, target) -> float:
	var input_value_normalized = context.get_input_value_normalized(input_type, actor, target)
	input_value_normalized = min(input_value_normalized, 1.0)
	var output = 0.0
	if not (0.0 > input_value_normalized or input_value_normalized > 1.0):
		output = utility_curve.sample_at(input_value_normalized)

	LOG.pr(LOG.LOG_TYPE.AI, "[%s] input:(%s), output:(%s)" %
		[self, input_value_normalized, output])
	return output


### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
