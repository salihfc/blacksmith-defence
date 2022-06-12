extends Resource
class_name UnitData
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

	COUNT		= 10,
}

# TODO: Can get rid of this
const STAT_NAMES = {
	STATS.MAX_HP		: "max_hp",

	STATS.RES_PHYS		: "resist_phys",
	STATS.RES_FIRE		: "resist_fire",
	STATS.RES_WATER		: "resist_water",
	STATS.RES_EARTH		: "resist_earth",

	STATS.BASE_DAMAGE	: "base_damage",
	STATS.MOVE_SPEED	: "move_speed",
	STATS.ATK_SPEED		: "atk_speed",
	STATS.ATK_RANGE		: "atk_range",
	STATS.DAMAGE_MULTI	: "damage_multi",
}

### CONST ###
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
# stats
export(float) var max_hp
export(float) var resist_phys	= 0.0
export(float) var resist_fire	= 0.0
export(float) var resist_water	= 0.0
export(float) var resist_earth	= 0.0

export(float) var base_damage	= 20.0
export(float) var move_speed	= 1.0	# pixel/second
export(float) var atk_speed		= 1.0	# attacks per second
export(float) var attack_range	= 24.0
export(float) var damage_multi	= 1.0

#
export(Resource) var weapon
export(Array, Resource) var spells

#
export(Resource) var enchancements = MaterialStorage.new()

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
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func get_view_texture():
	if view_texture:
		return view_texture
	return texture


func scale_to_wave(wave_number : float):
	for stat_id in STATS.COUNT:
		var curve_add = _get_stat_curve_add(stat_id)
		var curve_mult = _get_stat_curve_mult(stat_id)
		var value = get_stat(stat_id)

		if curve_add != null:
			value += curve_add.interpolate(wave_number)

			if stat_id == STATS.MAX_HP:
				LOG.pr(LOG.LOG_TYPE.INTERNAL, "[%s] set_stat [%s] to [%s] | (%s)" % [self, STAT_NAMES[stat_id], value, get_stat(stat_id)])

		if curve_mult != null:
			value *= curve_mult.interpolate(wave_number)

		_set_stat(stat_id, value)

	return self


func calc_power() -> float:
	var power = get_stat(STATS.MAX_HP)

	power *= get_stat(STATS.ATK_SPEED)
	power *= get_stat(STATS.DAMAGE_MULTI)

	if get_stat(STATS.ATK_RANGE):
		power *= max(1.0, sqrt(get_stat(STATS.ATK_RANGE)))

	return power


func get_stat(stat_id : int):
	return get(STAT_NAMES[stat_id])

### PRIVATE FUNCTIONS ###
func _set_stat(stat_id : int, new_value) -> void:
	set(STAT_NAMES[stat_id], new_value)


func _get_stat_curve_add(stat_id : int):
	return get(CURVE_ADD_NAME_PREFIX + STAT_NAMES[stat_id])


func _get_stat_curve_mult(stat_id : int):
	return get(CURVE_MULT_NAME_PREFIX + STAT_NAMES[stat_id])

### SIGNAL RESPONSES ###
