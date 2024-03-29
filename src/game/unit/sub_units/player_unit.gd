extends Unit
class_name PlayerUnit
"""
	NOTE:
		- PlayerUnits with spells cast their spells on certain frame of weapon swing animation
"""
### SIGNAL ###
### ENUM ###
### CONST ###
const P_Weapon = preload("res://src/game/player_units/weapon.tscn")
const RETARGET_MID_ANIMATION = true

### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func init_with_data(unit_recipe : UnitRecipe) -> void:
	#
	.init_with_data(unit_recipe)
	#
	# Set hp to max
#	_stats.set_stat(StatContainer.STATS.HP, get_stat(StatContainer.STATS.MAX_HP))

	var unit_data = unit_recipe.base_unit
	var enhance_cost = unit_recipe.enhance_cost
	assert(unit_data)
#	assert(unit_data.weapon)

	if unit_data.weapon:
		if unit_data.enhancements:
			for enh in unit_data.enhancements:
				enh.call_deferred("apply_to", self)

		var weapon_data = unit_data.weapon

		assert(enhance_cost == null or enhance_cost is MaterialCost)

		if enhance_cost:
			var materials = enhance_cost.get_materials()
			for mat in materials:
				var ct = enhance_cost.get_material_count(mat)
				for _i in ct:
					var enh = WEAPON_ENHANCE_DB.get_enhancement(weapon_data.name, MAT.get_type_name(mat))
					if enh:
						enh.call_deferred("apply_to", self)

		if unit_data.weapon is WeaponData:
			var new_weapon = P_Weapon.instance()
			_set_weapon(new_weapon)
			new_weapon.init_with_data(unit_data.weapon)
			new_weapon.set_animation_speed(unit_data.get_stat(StatContainer.STATS.ATK_SPEED))

	if unit_data.spells:
		for spell_scene in unit_data.spells:
			var spell = spell_scene.instance()
			spellSlot.call_deferred("add_child", spell)
			spell.call_deferred("set_owner_unit", self)
			SIGNAL.bind(
					spell, "enemy_hit",
					self, "_on_enemy_hit")

	if unit_data.throwables:
		for throwable_scene in unit_data.throwables:
			var throwable = throwable_scene.instance()
			throwSlot.call_deferred("add_child", throwable)
			throwable.call_deferred("set_owner_unit", self)
#			SIGNAL.bind(
#					throwable, "enemy_hit",
#					self, "_on_enemy_hit")

	DBG_range_circle.modulate = Color.green
	DBG_range_circle.modulate.a = 0.1

	_stats.call_deferred("set_stat_equal_to_other_stat", StatContainer.STATS.MAX_HP, StatContainer.STATS.HP)


### PUBLIC FUNCTIONS ###
### PRIVATE FUNCTIONS ###
func _set_weapon(weapon : Node) -> void:
	weaponSlot.add_weapon(weapon)

	SIGNAL.bind_bulk(
			weapon, self,
			[
				["damage_frame", "_on_weapon_attack_frame"],
				["enemy_hit_with_damage", "_on_enemy_hit"],
			])

	weapon.set_owner_unit(self)

	if weapon.has_method("set_damage"):
		weapon.set_damage(get_damage())
	else:
		LOG.pr(LOG.LOG_TYPE.INTERNAL, "Cannot set weapon damage [%s -> %s]" % [self, weapon])


func _set_area_layer_and_masks() -> void:
	body.collision_layer = COLLISION.PLAYER
	attackRange.collision_mask = COLLISION.ENEMY

### SIGNAL RESPONSES ###
func _on_weapon_attack_frame(_damage) -> void:
#	attack()
	LOG.pr(LOG.LOG_TYPE.INTERNAL, "[%s] weapon attack frame casting spells" % [self])
	for spell in spellSlot.get_children():
		spell.cast()

	for throwable in throwSlot.get_children():
		throwable.throw()
