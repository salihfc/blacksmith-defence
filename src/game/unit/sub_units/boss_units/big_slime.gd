extends BossEnemyUnit
class_name BigSlime
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
var _damage_taken_accumulator : Accumulator
#var _unit_to_summon

### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func init_with_data(unit_recipe : UnitRecipe) -> void:
	.init_with_data(unit_recipe)

	var unit_data = unit_recipe.base_unit as BigSlimeData
	assert(unit_data)

#	_unit_to_summon = unit_data.unit_to_summon
	_damage_taken_accumulator = Accumulator.new(unit_data.summon_threshold)

	SIGNAL.bind(
			_damage_taken_accumulator, "limit_reached",
			self, "_on_enough_damage_taken",
			[unit_data.unit_to_summon]
	)


### PUBLIC FUNCTIONS ###
func take_damage(_damage, pulse = Vector2.ZERO) -> void:
	.take_damage(_damage, pulse)

	if _damage is Damage:
		_damage_taken_accumulator.add(calc_final_damage_amount(_damage))

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###

func _on_enough_damage_taken(unit_to_summon : UnitData) -> void:
	LOG.pr(LOG.LOG_TYPE.INTERNAL, " ACC TRIGGER [%s] [%s] " % [self, _damage_taken_accumulator.get_threshold()])

	var copy = UnitData.new().copy_from(unit_to_summon)
	copy.get_stat_container().set_stat(StatContainer.STATS.MAX_HP, _damage_taken_accumulator.get_threshold())

	var effect = OnDeathEffectSummonUnit.new([copy])
	effect.trigger(self)
	_damage_taken_accumulator.clear()
