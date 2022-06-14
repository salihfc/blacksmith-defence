tool
extends Resource
class_name UnitData
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
const STAT_DEFAULTS = {
	StatContainer.STATS.MAX_HP : 50,
	StatContainer.STATS.BASE_DAMAGE : 10,
	StatContainer.STATS.DAMAGE_MULTI : 1,
	StatContainer.STATS.MOVE_SPEED : 1,
	StatContainer.STATS.ATK_SPEED : 1,

	StatContainer.STATS.CHAIN_COUNT : 0,

	StatContainer.STATS.ATK_RANGE : 40,
}

const CURVE_MULT_NAME_PREFIX	= "curve_mult_"
const CURVE_ADD_NAME_PREFIX		= "curve_add_"

### EXPORT ###
# Visual
export(String) var name
export(Texture) var texture
export(Texture) var view_texture
export(Resource) var cost = MaterialStorage.new() # MaterialStorage

# AI
export(Resource) var brain = null # Type: Agent

# Battle
var _stats = StatContainer.new()

#
export(Resource) var weapon
export(Array, Resource) var spells

#
#export(Resource) var enhancements = MaterialStorage.new()
export(Array, Resource) var enhancements = []

# curves
export(Curve) var curve_add_max_hp
export(Curve) var curve_add_resist_phys
export(Curve) var curve_add_resist_fire
export(Curve) var curve_add_resist_water
export(Curve) var curve_add_resist_earth

export(Curve) var curve_add_base_damage
export(Curve) var curve_add_move_speed
export(Curve) var curve_add_atk_speed
export(Curve) var curve_add_attack_range
export(Curve) var curve_add_damage_multi

export(Curve) var curve_mult_max_hp
export(Curve) var curve_mult_resist_phys
export(Curve) var curve_mult_resist_fire
export(Curve) var curve_mult_resist_water
export(Curve) var curve_mult_resist_earth

export(Curve) var curve_mult_base_damage
export(Curve) var curve_mult_move_speed
export(Curve) var curve_mult_atk_speed
export(Curve) var curve_mult_attack_range
export(Curve) var curve_mult_damage_multi

### PUBLIC VAR ###
### PRIVATE VAR ###
var _props = []
func _get(property: String):
	if _stats.has(property):
		return _stats.get(property)
	return null


func _set(property: String, value = false) -> bool:
	if _stats.has(property):
		_stats.set(property, value)

	for idx in StatContainer.STATS.COUNT:
		if _stats.get_stat(idx, 0) == 0:
			_stats.set_stat(idx, STAT_DEFAULTS.get(idx, 0.0))

	return true


func _get_property_list() -> Array:
	return _props


### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _init() -> void:

	for idx in StatContainer.STATS.COUNT:
		_props.append(
			{
				'name' : StatContainer.get_stat_name(idx),
				'type' : StatContainer.get_stat_type(idx),
			}
		)

		_set_stat(idx, STAT_DEFAULTS.get(idx, 0.0))


### PUBLIC FUNCTIONS ###
func get_texture():
	return texture


func get_view_texture():
	if view_texture:
		return view_texture
	return get_texture()


func scale_to_wave(wave_number : float):
	for stat_id in StatContainer.STATS.COUNT:
		var curve_add = _get_stat_curve_add(stat_id)
		var curve_mult = _get_stat_curve_mult(stat_id)
		var value = get_stat(stat_id)

		if curve_add != null:
			value += curve_add.interpolate(wave_number)

			if stat_id == StatContainer.STATS.MAX_HP:
				LOG.pr(LOG.LOG_TYPE.INTERNAL, "[%s] set_stat [%s] to [%s] | (%s)" % [self, UTILS.get_enum_string_from_id(StatContainer.STATS, stat_id), value, get_stat(stat_id)])

		if curve_mult != null:
			value *= curve_mult.interpolate(wave_number)

		_set_stat(stat_id, value)

	return self


func calc_power() -> float:
	var power = get_stat(StatContainer.STATS.MAX_HP)

	power *= get_stat(StatContainer.STATS.ATK_SPEED)
	power *= get_stat(StatContainer.STATS.DAMAGE_MULTI)

	if get_stat(StatContainer.STATS.ATK_RANGE):
		power *= max(1.0, sqrt(get_stat(StatContainer.STATS.ATK_RANGE)))

	return power


"""
	NOTE:
		CUSTOM RESOURCES require custom duplicate functions like this to ensure copying
"""
func copy_stats():
	var copy_stats = StatContainer.new()
	copy_stats.from_data(_stats.get_data_copy())
	return copy_stats


func get_stat(stat_id : int):
	return _stats.get_stat(stat_id)

### PRIVATE FUNCTIONS ###
func _set_stat(stat_id : int, new_value) -> void:
	_stats.set_stat(stat_id, new_value)


func _get_stat_curve_add(stat_id : int):
	return get(CURVE_ADD_NAME_PREFIX + StatContainer.get_stat_name(stat_id))


func _get_stat_curve_mult(stat_id : int):
	return get(CURVE_MULT_NAME_PREFIX + StatContainer.get_stat_name(stat_id))

### SIGNAL RESPONSES ###
