extends Curve
class_name UtilityCurve

"""

"""

### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func sample_at(x : float) -> float:
	if x == IAUS.NULL:
		return 0.0

	assert(x >= min_value and x <= max_value)
	return interpolate(x)
	
### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
