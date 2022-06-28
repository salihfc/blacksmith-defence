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

var TEXT_COLORS = {
	TYPE.PHYSICAL	: Color.wheat,
	TYPE.FIRE		: Color.firebrick,
	TYPE.EARTH		: Color.yellowgreen,
	TYPE.WATER		: Color.aqua,
	TYPE.LIGHTNING	: Color.gold.lightened(0.2),
}

### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
var _type
var _amount

### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _init(p_type : int = TYPE.COUNT, p_amount : float = 0.0):
	_type = p_type
	_amount = p_amount


func copy_from(other):
	_type = other.get_type()
	_amount = other.get_amount()
	return self

### PUBLIC FUNCTIONS ###
func get_type():
	return _type


func get_resist_type():
	return RESIST_TYPES.get(_type)


func get_text_color():
	return TEXT_COLORS.get(_type)


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
