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

	CHAIN_COUNT = 10,

	HP			= 11,

	BLEED_CHANCE	= 12,
	IGNITE_CHANCE	= 13,
	ARMOR_BREAK_CHANCE	= 14,
	POISON_CHANCE	= 15,
	FREEZE_CHANCE	= 16,
	CHILL_CHANCE	= 17,
	SHOCK_CHANCE	= 18,
	STUN_CHANCE		= 19,

	SPELL_AOE	= 20,
	CAST_SPEED	= 21,
	CAST_RANGE	= 22,
	CHAIN_RANGE = 23,

	ARMOR_PEN	= 24,
	BASE_KNOCKBACK_STRENGTH = 25,

	COUNT,
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
var _props = []
func _get_property_list() -> Array:
	return _props


### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _init() -> void:
	for idx in STATS.COUNT:
		_props.append(
			{
				'name' : get_stat_name(idx),
				'type' : get_stat_type(idx),
			}
		)


### PUBLIC FUNCTIONS ###
func increase_stat(id : int, amount) -> void:
	assert(has_stat(id))
	set_stat(id, get_stat(id) + amount)


func multiply_stat(id : int, amount) -> void:
	assert(has_stat(id))
	set_stat(id, get_stat(id) * amount)


func has(property : String) -> bool:
	return _data.has(property)


func has_stat(id : int) -> bool:
	return has(get_stat_name(id))


func get_stat(id : int, default = 0):
	var property = get_stat_name(id)
	return _data.get(property, default)


func set_stat(id : int, value) -> void:
	var property = get_stat_name(id)
	_data[property] = value


func get_data_copy():
	return _data.duplicate(true)


func from_data(data):
	_data = data
	return self


# Get stats as {stat_name: stat_value} dict
func get_stat_list():
	return _data

### PRIVATE FUNCTIONS ###
func _get(property: String, default = null):
	return _data.get(property, default)


func _set(property: String, value) -> bool:
	_data[property] = value
	return true
### SIGNAL RESPONSES ###
