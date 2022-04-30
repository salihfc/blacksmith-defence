extends IAUSObject
class_name Consideration

"""

"""

### SIGNAL ###


### ENUM ###

### CONST ###


### EXPORT ###
export(Resource) var utility_curve = UtilityCurve.new()
export(IAUS.INPUT) var input_type = IAUS.INPUT.NONE

### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###




### VIRTUAL FUNCTIONS (_init ...) ###


### PUBLIC FUNCTIONS ###
func utility(context, actor, target) -> float:
	var input_value_normalized = _extract_input_value_from_context(context, actor, target)
	if 0.0 > input_value_normalized or input_value_normalized > 1.0:
		return 0.0
	return utility_curve.interpolate_baked(input_value_normalized)


### PRIVATE FUNCTIONS ###
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _extract_input_value_from_context(context, actor : Unit, target) -> float:
	
	match input_type:
		IAUS.INPUT.NONE:
			return 0.0

		IAUS.INPUT.HP_PERC:
			return actor.get_hp_perc()

		IAUS.INPUT.ENEMY_IN_RANGE:
			# for now return value based on closest enemy
			return actor.get_closest_enemy_dist_in_aggro_range_normalized()
		
		IAUS.INPUT.ENEMY_IN_ATTACK_RANGE:
			return actor.get_closest_enemy_dist_in_attack_range_normalized()
	
	return 0.0


### SIGNAL RESPONSES ###
