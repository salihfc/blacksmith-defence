extends Unit
class_name EnemyUnit
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(float) var drop_chance = 0.5

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _ready():
	add_to_group(CONFIG.ENEMY_GROUP)
	default_state = STATE.WALK
	change_state(STATE.WALK)

### PUBLIC FUNCTIONS ###
func init_with_data(unit_recipe : UnitRecipe) -> void:
	.init_with_data(unit_recipe)
	DBG_range_circle.modulate = Color.red
	DBG_range_circle.modulate.a = 0.1

	var unit_data = unit_recipe.base_unit as UnitData
	if unit_data.enhancements:
		for enh in unit_data.enhancements:
			enh.call_deferred("apply_to", self)

	if unit_data.mods:
		for mod in unit_data.mods:
			mod.call_deferred("apply_to", self)


func get_default_dir():
	return Vector2.LEFT


func set_direction() -> void:
	spriteParent.scale.x = -_velocity.x / abs(_velocity.x)


func attack() -> void:
	if _target_weakref:
		var _target = _target_weakref.get_ref()
		if _target == null: # reselect target if previous one dies mid animation
			_target = _select_target()

		if _target and is_unit_in_attack_range(_target): # make sure there are enemies around to attack
			var damage = Damage.new(Damage.TYPE.PHYSICAL, get_damage()).set_originator(self)
			LOG.pr(LOG.LOG_TYPE.GAMEPLAY, "[%s] : Attacking [%s] for {%s}" % [self, _target, damage])
			_target.take_damage(damage)
		else:
			yield(animPlayer, "animation_finished")
			emit_signal("_context_changed")


### PRIVATE FUNCTIONS ###
func _set_area_layer_and_masks() -> void:
	body.collision_layer = COLLISION.ENEMY
	attackRange.collision_mask = COLLISION.PLAYER | COLLISION.PLAYER_BASE

### SIGNAL RESPONSES ###
func _on_death() -> void:
	if UTILS.check(drop_chance):
		GROUP.get_global(GROUP.BATTLE_WORLD).spawn_random_mat_drop(global_position)

	._on_death()
