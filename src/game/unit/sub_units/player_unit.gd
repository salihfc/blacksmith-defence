extends Unit
class_name PlayerUnit

"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###
const RETARGET_MID_ANIMATION = true

### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###


### VIRTUAL FUNCTIONS (_init ...) ###
func init_with_data(unit_data : UnitData) -> void:
	.init_with_data(unit_data)
	
	if unit_data.weapon:
		UTILS.clear_children(weaponSlot)
		var new_weapon = WEAPON_FACTORY.create_weapon(unit_data.weapon)
		weaponSlot.add_child(new_weapon)
		new_weapon.set_animation_speed(unit_data.atk_speed)
		
		UTILS.bind(
			new_weapon, "damage_frame",
			self, "_on_weapon_attack_frame"
		)


### PUBLIC FUNCTIONS ###

func attack() -> void:
	if _target_weakref and weaponSlot.get_child_count() > 0:
		var _target = _target_weakref.get_ref()
		LOG.pr(3, "[%s] : Attacking [%s]" % [self, _target])

		if _target == null and RETARGET_MID_ANIMATION: # reselect target if previous one dies mid animation
			_target = _select_target()

		if _target: # make sure there are enemies around to attack
			var direction = global_position.direction_to(_target.global_position)
			var strength = 140.0
			var pulse = direction * strength
			_target.take_damage(Damage.new(Damage.TYPE.PHYSICAL, get_damage()), pulse)


### PRIVATE FUNCTIONS ###
func _set_area_layer_and_masks() -> void:
	body.collision_layer = COLLISION.PLAYER
	attackRange.collision_mask = COLLISION.ENEMY


### SIGNAL RESPONSES ###
func _on_weapon_attack_frame(_damage) -> void:
	attack()
