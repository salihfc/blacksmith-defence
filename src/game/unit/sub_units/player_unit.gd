extends Unit
class_name PlayerUnit

"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###
const PrefabWeapon = preload("res://src/game/player_units/weapon.tscn")
const RETARGET_MID_ANIMATION = true

### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###


### VIRTUAL FUNCTIONS (_init ...) ###
func init_with_data(unit_data : UnitData) -> void:
	.init_with_data(unit_data)
	
	if unit_data.weapon is WeaponData:
		var new_weapon = PrefabWeapon.instance()
		_set_weapon(new_weapon)
		new_weapon.init_with_data(unit_data.weapon)
		new_weapon.set_animation_speed(unit_data.atk_speed)

	if unit_data.spells:
		for spell_scene in unit_data.spells:
			spellSlot.add_child(spell_scene.instance())

#	elif unit_data.weapon is PackedScene:
#		_set_weapon(unit_data.weapon.instance())


	if unit_data.attack_range:
		attackRange.set_radius(unit_data.attack_range)


### PUBLIC FUNCTIONS ###

func attack() -> void:
	return
#	if _target_weakref and weaponSlot.get_child_count() > 0:
#		var _target = _target_weakref.get_ref()
#		LOG.pr(3, "[%s] : Attacking [%s]" % [self, _target])
#
#		if _target == null and RETARGET_MID_ANIMATION: # reselect target if previous one dies mid animation
#			_target = _select_target()
#
#		if _target: # make sure there are enemies around to attack
#			var direction = global_position.direction_to(_target.global_position)
#			var strength = 140.0
#			var pulse = direction * strength
#			_target.take_damage(Damage.new(Damage.TYPE.PHYSICAL, get_damage()), pulse)


### PRIVATE FUNCTIONS ###
func _set_weapon(weapon : Node) -> void:
	UTILS.clear_children(weaponSlot)
	UTILS.bind(
		weapon, "damage_frame",
		self, "_on_weapon_attack_frame"
	)

	weaponSlot.add_child(weapon)
	
	if weapon.has_method("set_damage"):
		weapon.set_damage(get_damage())
	else:
		LOG.pr(4, "Cannot set weapon damage [%s -> %s]" % [self, weapon])


func _set_area_layer_and_masks() -> void:
	body.collision_layer = COLLISION.PLAYER
	attackRange.collision_mask = COLLISION.ENEMY


### SIGNAL RESPONSES ###
func _on_weapon_attack_frame(_damage) -> void:
	attack()
	for spell in spellSlot.get_children():
		spell.cast()
