extends Unit
class_name PlayerUnit
"""
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
func init_with_data(unit_data : UnitData) -> void:
	.init_with_data(unit_data)

	if unit_data.weapon is WeaponData:
		var new_weapon = P_Weapon.instance()
		_set_weapon(new_weapon)
		new_weapon.init_with_data(unit_data.weapon)
		new_weapon.set_animation_speed(unit_data.get_stat(StatContainer.STATS.ATK_SPEED))

	if unit_data.spells:
		for spell_scene in unit_data.spells:
			spellSlot.add_child(spell_scene.instance())

	DBG_range_circle.modulate = Color.green
	DBG_range_circle.modulate.a = 0.1

### PUBLIC FUNCTIONS ###
# DANGER: Deleting base function
func attack() -> void:
	return

### PRIVATE FUNCTIONS ###
func _set_weapon(weapon : Node) -> void:
	UTILS.clear_children(weaponSlot)
	SIGNAL.bind(
		weapon, "damage_frame",
		self, "_on_weapon_attack_frame"
	)

	weaponSlot.add_child(weapon)

	if weapon.has_method("set_damage"):
		weapon.set_damage(get_damage())
	else:
		LOG.pr(LOG.LOG_TYPE.INTERNAL, "Cannot set weapon damage [%s -> %s]" % [self, weapon])


func _set_area_layer_and_masks() -> void:
	body.collision_layer = COLLISION.PLAYER
	attackRange.collision_mask = COLLISION.ENEMY

### SIGNAL RESPONSES ###
func _on_weapon_attack_frame(_damage) -> void:
	attack()
	for spell in spellSlot.get_children():
		spell.cast()
