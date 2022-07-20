extends Node2D
class_name Weapon
"""
"""
### SIGNAL ###
signal damage_frame(damage_amount)
signal enemy_hit_with_damage(target, damage)

### ENUM ###
### TODO: fix this
enum TYPE {
	SWORD = 0,
	RAPIER = 1,

	WAND = 2,
	SPEAR = 3,
}
### <-- TEMP

enum ANIM {
	IDLE,
	HOLD,
	SWING,
	SLAM,
	THRUST,

	COUNT
}

### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
var _owner = null setget set_owner_unit
var _id = -1
var _damage = 0.0

### ONREADY VAR ###
onready var sprite = $Sprite as Sprite
onready var animPlayer = $AnimationPlayer as AnimationPlayer
onready var collisionShape = $Sprite/HitBox/CollisionShape2D as CollisionShape2D
onready var vfxWeaponParticles = $Sprite/VFXWeaponParticles

### VIRTUAL FUNCTIONS (_init ...) ###
# warning-ignore:unused_argument
func init_with_data(weapon_data : WeaponData) -> void:
	_id = weapon_data.id
	sprite.texture = weapon_data.texture
	# ANIM SETUP
	vfxWeaponParticles.modulate = weapon_data.particle_color

	for id in ANIM.COUNT:
		var anim_name = get_anim(id)
		var member_name = anim_name + "_anim"
		var anim = weapon_data.get(member_name)
		if anim:
			animPlayer.add_animation(anim_name, anim)

	# PHYSICS
	collisionShape.shape = weapon_data.collision_shape
	collisionShape.position = weapon_data.collision_shape_offset

	# GAMEPLAY
	_damage = weapon_data.base_damage

	# Start Idle animation
	if animPlayer.has_animation(get_anim(ANIM.IDLE)):
		animPlayer.play(get_anim(ANIM.IDLE))

### PUBLIC FUNCTIONS ###
func strike() -> void:
	match _id:
		TYPE.SWORD, TYPE.SPEAR:
			animate(ANIM.SWING)
		TYPE.RAPIER:
			animate(ANIM.THRUST)

		TYPE.WAND:
			animate(ANIM.SWING)

		_:
			assert(0)


func animate(anim_id) -> void:
	var speed = animPlayer.playback_speed
	animPlayer.stop(true)
	animPlayer.playback_speed = speed
	animPlayer.advance(0.0)
	animPlayer.play(get_anim(anim_id))


func get_anim(id):
	return UTILS.get_enum_string_from_id(ANIM, id).to_lower()


func set_animation_speed(speed : float) -> void:
	animPlayer.set_speed_scale(speed)


func set_owner_unit(__owner) -> void:
	_owner = __owner


func set_damage(damage) -> void:
	_damage = damage


func get_damage():
	assert(_owner)

	return CumulativeDamage.new(
		[
			Damage.new(
					Damage.TYPE.PHYSICAL,\
					_damage + _get_owner_stat(StatContainer.STATS.BASE_DAMAGE)
			).set_originator(_owner),
		]
	)

### PRIVATE FUNCTIONS ###

func _deal_damage(entity) -> void:
	assert(entity.has_method("take_damage"))
	var knockback_strength = _get_owner_stat(StatContainer.STATS.BASE_KNOCKBACK_STRENGTH)
#	LOG.pr(LOG.LOG_TYPE.GAMEPLAY, "[%s] knockback [%s], [%s]" % [_owner, knockback_strength, _get_knockback_dir() * knockback_strength])
	entity.take_damage(get_damage(), _get_knockback_dir() * knockback_strength)
	emit_signal("enemy_hit_with_damage", entity, get_damage())


func _get_knockback_dir() -> Vector2:
#	global_position.direction_to(entity.global_position)
	return Vector2.RIGHT


func _get_owner_stat(stat_id):
	return _owner.get_stat(stat_id)


func _play_sfx() -> void:
	match _id:
		TYPE.RAPIER:
			AUDIO.play(AUDIO.SFX.WEAPON_RAPIER_THRUST)

		TYPE.SWORD:
			AUDIO.play(AUDIO.SFX.WEAPON_SWORD_SWING)

		_:
			LOG.pr(LOG.LOG_TYPE.SFX, "Weapon[%s] dont have sfx!!!" % [_id])

### SIGNAL RESPONSES ###
func _send_damage_frame() -> void:
	LOG.pr(LOG.LOG_TYPE.INTERNAL, "Send damage frame")
	emit_signal("damage_frame", get_damage())


func _on_HitBox_area_entered(area):
	var entity_hit = area.get_owner()
	LOG.pr(LOG.LOG_TYPE.PHYSICS, "Hitbox entered %s" % [entity_hit])
	_deal_damage(entity_hit)

	var spawn_pos = entity_hit.global_position

	# Random displacement
	spawn_pos += UTILS.random_unit_vec2() * 10.0

	# TODO: make dynamic
	if _id == TYPE.RAPIER:
		VFX.generate_fx_at(VFX.FX.THRUST_HIT_PARTICLES, spawn_pos)
	elif _id == TYPE.SWORD:
		VFX.generate_fx_at(VFX.FX.SWING_HIT_PARTICLES, spawn_pos)


# warning-ignore:unused_argument
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name != get_anim(ANIM.IDLE) and animPlayer.has_animation(get_anim(ANIM.IDLE)):
		animPlayer.play(get_anim(ANIM.IDLE))
	pass
