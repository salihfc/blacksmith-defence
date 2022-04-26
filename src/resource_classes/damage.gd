extends Resource
class_name Damage

"""
	
"""

### SIGNAL ###


### ENUM ###
enum TYPE {
	PHYSICAL,
	
	
	COUNT,
}

### CONST ###
const TYPE_NAMES = {
	TYPE.PHYSICAL : "PHYS",
}

### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###
var _type
var _amount

### ONREADY VAR ###


### VIRTUAL FUNCTIONS (_init ...) ###
func _init(p_type : int, p_amount : float):
	_type = p_type
	_amount = p_amount


### PUBLIC FUNCTIONS ###


### PRIVATE FUNCTIONS ###
func _to_string():
	return "[%s.%s]" % [TYPE_NAMES[_type], _amount]

### SIGNAL RESPONSES ###
