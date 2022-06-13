tool
extends Resource
class_name StatContainer
"""
"""

### SIGNAL ###
### ENUM ###
enum STATS {
	MAX_HP		= 0,

	RES_PHYS	= 1,
	RES_FIRE	= 2,
	RES_WATER	= 3,
	RES_EARTH	= 4,

	BASE_DAMAGE	= 5,
	MOVE_SPEED	= 6,
	ATK_SPEED	= 7,

	ATK_RANGE	= 8,
	DAMAGE_MULTI= 9,

	HP = 10,

	COUNT		= 11,
}

static func get_real_typed():
	return range(STATS.MAX_HP, STATS.COUNT)


static func get_stat_name(id):
	return STATS_EDITOR_PREFIX + UTILS.get_enum_string_from_id(STATS, id).to_lower()


static func get_stat_type(id):
	if id in get_real_typed():
		return TYPE_REAL
	return TYPE_NIL

### CONST ###
const STATS_EDITOR_PREFIX = "stats/"

### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
var _data = {}

### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func has(property : String) -> bool:
	return _data.has(property)


func has_stat(id : int) -> bool:
	return has(get_stat_name(id))


func get_stat(id : int, default = null):
	var property = get_stat_name(id)
	return _data.get(property, default)


func set_stat(id : int, value) -> void:
	var property = get_stat_name(id)
	_data[property] = value


func get_data_copy():
	return _data.duplicate(true)


func from_data(data) -> void:
	_data = data

### PRIVATE FUNCTIONS ###
func _get(property: String, default = null):
	return _data.get(property, default)


func _set(property: String, value) -> bool:
	_data[property] = value
	return true

### SIGNAL RESPONSES ###
