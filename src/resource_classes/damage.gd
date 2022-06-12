extends Resource
class_name Damage
"""
"""
### SIGNAL ###
### ENUM ###
enum TYPE {
	PHYSICAL,

	FIRE,
	WATER,
	EARTH,
	LIGHTNING,

	COUNT,
}

### CONST ###
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
func get_type():
	return _type


func get_amount():
	return _amount

### PRIVATE FUNCTIONS ###
func _to_string():
	return "[%s.%s]" % [_get_typename(_type), _amount]


func _get_typename(id):
	return UTILS.get_enum_string_from_id(TYPE, id)

### SIGNAL RESPONSES ###
