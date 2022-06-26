extends OnDeathEffect
class_name OnDeathEffectSummonUnit
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
const RANDOM_OFFSET_MAG = 5.0

### EXPORT ###
export(Array, Resource) var to_be_summoned_units = []

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func copy_from_prototype(_prototype):
	to_be_summoned_units = _prototype.to_be_summoned_units.duplicate(true)
	return self


func _init(summon_units = []) -> void:
	to_be_summoned_units = summon_units

### PUBLIC FUNCTIONS ###
func trigger(_subject) -> void:
	LOG.pr(LOG.LOG_TYPE.INTERNAL, "OnDeathEffectSummonUnit > working")
	var subject_pos = _subject.global_position

	if _subject is EnemyUnit:
		for unit_data in to_be_summoned_units:
			var summon_pos = subject_pos + Vector2.UP * rand_range(-RANDOM_OFFSET_MAG, RANDOM_OFFSET_MAG)

			_subject.get_tree().call_group(
				"battle_world",
				"spawn_enemy_at_pos", unit_data, summon_pos
			)


### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###

