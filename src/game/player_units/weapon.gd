extends Node2D
class_name Weapon

"""

"""

### SIGNAL ###
signal damage_frame(damage_amount)


### ENUM ###
### TEMP
enum TYPE {
	SWORD = 0,
	RAPIER = 1,
	
}
### <-- TEMP


enum ANIM {
	HOLD,
	SWING,
	SLAM,
	THRUST,

}

### CONST ###
const ANIMS = {
	ANIM.HOLD	: "hold",
	ANIM.SWING	: "swing",
	ANIM.SLAM	: "slam",
	ANIM.THRUST : "thrust",
}

### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###
var _id = -1
var _damage = 0.0

### ONREADY VAR ###
onready var sprite = $Sprite as Sprite
onready var animPlayer = $AnimationPlayer as AnimationPlayer
onready var collisionShape = $Sprite/HitBox/CollisionShape2D as CollisionShape2D 

### VIRTUAL FUNCTIONS (_init ...) ###
# warning-ignore:unused_argument
func init_with_data(weapon_data : WeaponData) -> void:
	_id = weapon_data.id
	sprite.texture = weapon_data.texture
	# ANIM SETUP
	
	if weapon_data.hold_anim:
		animPlayer.add_animation("hold", weapon_data.hold_anim)
	if weapon_data.swing_anim:
		animPlayer.add_animation("swing", weapon_data.swing_anim)
	if weapon_data.slam_anim:
		animPlayer.add_animation("slam", weapon_data.slam_anim)
	if weapon_data.thrust_anim:
		animPlayer.add_animation("thrust", weapon_data.thrust_anim)

	# PHYSICS
	collisionShape.shape = weapon_data.collision_shape
	collisionShape.position = weapon_data.collision_shape_offset

	# GAMEPLAY
	_damage = weapon_data.base_damage

  
### PUBLIC FUNCTIONS ###
func strike() -> void:
	match _id:
		TYPE.SWORD:
			animate(ANIM.SWING)
		TYPE.RAPIER:
			animate(ANIM.THRUST)


func animate(anim_id) -> void:
	animPlayer.stop()
	animPlayer.play(get_anim(anim_id))


func get_anim(id):
	return ANIMS[id]


func set_animation_speed(speed : float) -> void:
	animPlayer.set_speed_scale(speed)


func set_damage(damage) -> void:
	_damage = damage


func get_damage():
	return Damage.new(Damage.TYPE.PHYSICAL, _damage)

### PRIVATE FUNCTIONS ###

func _deal_damage(entity) -> void:
	assert(entity.has_method("take_damage"))
	entity.take_damage(get_damage())
	

### SIGNAL RESPONSES ###
func _send_damage_frame() -> void:
	emit_signal("damage_frame", get_damage())


func _on_HitBox_area_entered(area):
	LOG.pr(3, "Hitbox entered %s" % [area.get_owner()])
	_deal_damage(area.get_owner())
