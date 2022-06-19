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
var RESIST_TYPES = {
	TYPE.PHYSICAL	: StatContainer.STATS.RES_PHYS,
	TYPE.FIRE		: StatContainer.STATS.RES_FIRE,
	TYPE.EARTH		: StatContainer.STATS.RES_EARTH,
	TYPE.WATER		: StatContainer.STATS.RES_WATER,
	TYPE.LIGHTNING	: StatContainer.STATS.RES_WATER,
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
func get_type():
	return _type


func get_resist_type():
	return RESIST_TYPES.get(_type)


func get_amount():
	return _amount


func increased_by(amount):
	_amount += amount
	return self

### PRIVATE FUNCTIONS ###
func _to_string():
	return "[%s.%s]" % [_get_typename(_type), _amount]


func _get_typename(id):
	return UTILS.get_enum_string_from_id(TYPE, id)

### SIGNAL RESPONSES ###
