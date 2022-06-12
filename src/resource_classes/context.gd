extends Resource
class_name Context
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
var _world = null

### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func get_input_value_normalized(input_type : int, actor, target = null) -> float:

	match input_type:
		IAUS.INPUT.NONE:
			return IAUS.NULL

		IAUS.INPUT.HP_PERC:
			return actor.get_hp_perc()

		IAUS.INPUT.ENEMY_IN_RANGE:
#			return actor.get_closest_enemy_dist_in_aggro_range_normalized()
			if target and actor.is_unit_in_range(target):
				return actor.normalized_distance_to_unit(target)
			return IAUS.NULL

		IAUS.INPUT.ENEMY_IN_ATTACK_RANGE:
#			return actor.get_closest_enemy_dist_in_attack_range_normalized()
			if target and actor.is_unit_in_attack_range(target):
				return actor.normalized_distance_to_unit(target)
			return IAUS.NULL

	return IAUS.NULL


func set_world(world) -> void:
	_world = world


func get_world():
	return _world

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
