extends Node2D
class_name ThrowableWeapon
"""
"""
### SIGNAL ###
signal landed()
signal enemy_hit(target, damage)

### ENUM ###
### CONST ###
const EPSILON = 0.1

### EXPORT ###
export(Resource) var damage = Damage.new()

export(float) var min_dist_to_throw
export(float) var max_velocity
export(float) var height_scale
#export(float) var max_z_velocity
#export(float) var gravity

export(Curve) var height_curve : Curve
export(Curve) var dist_to_height_multi : Curve

export(PackedScene) var P_LandVFX

### PUBLIC VAR ###
var owner_unit_weakref

### PRIVATE VAR ###
var _thrown = false
var _velocity = Vector2.ZERO
var _start_pos : Vector2
var _target_pos : Vector2
var _max_dist = INF
var _t = 0.0
var _h_multi = 1.0

var base_radius = 80.0
var _radius = 80.0

### ONREADY VAR ###
onready var sprite = $Pivot/Sprite as Sprite
onready var pivot = $Pivot as Node2D
onready var collision_shape = $Pivot/Sprite/HitBox/CollisionShape2D as CollisionShape2D
onready var hitBox = $Pivot/Sprite/HitBox as ObjectArea

### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	hide()
	SIGNAL.bind(self, "landed", self, "_on_landing")


func _physics_process(delta: float) -> void:
	if _thrown:
		assert(_target_pos != null)

		if global_position.distance_to(_target_pos) < _velocity.length() * delta:
			stop()
		else:
			global_position += _velocity * delta
			_t = t(_start_pos.distance_to(global_position), _max_dist)

			var h = (height_curve.interpolate_baked(_t) * height_scale) * _h_multi
			_set_offset(-max(0, h))

			var dx = EPSILON
			var dy = height_curve.interpolate_baked(_t + dx) - height_curve.interpolate_baked(_t)
			var rads = atan2(-dy, height_curve.max_value)
#			LOG.pr(LOG.LOG_TYPE.INTERNAL, "rads[%s] {%s / %s}" % [rads, dy, dx])
			pivot.rotation = rads

			# Fix the horizontal look direction
			scale.x *= sign(_velocity.x)


### PUBLIC FUNCTIONS ###
func set_owner_unit(_unit) -> void:
	owner_unit_weakref = weakref(_unit)
	var owner_spell_aoe = _unit.get_stat(StatContainer.STATS.SPELL_AOE)

	LOG.pr(LOG.LOG_TYPE.INTERNAL, "|||||||||||||owner_aoe|||||||||||| > [%s]" % [owner_spell_aoe])
	if owner_spell_aoe:
		_set_radius(get_radius() * owner_spell_aoe)


func get_owner():
	if owner_unit_weakref:
		return owner_unit_weakref.get_ref()
	return null


func stop():
	_set_offset(0.0)
	_thrown = false
	_velocity = Vector2.ZERO
	emit_signal("landed")
	position = Vector2.ZERO + Vector2.UP * 16.0


func can_throw() -> bool:
	return _thrown == false


func throw(target_pos : Vector2 = decide_target_pos()) -> void:
	if target_pos == null or target_pos.distance_to(global_position) < min_dist_to_throw:
		return

	show()
	_thrown = true
	_start_pos = global_position
	_target_pos = target_pos
	_max_dist = _start_pos.distance_to(target_pos)
	_velocity = global_position.direction_to(target_pos) * max_velocity

	_h_multi = dist_to_height_multi.interpolate_baked(clamp(_max_dist / 2000.0, 0.0, 1.0))


func t(x, max_dist) -> float:
	return lerp(0.25, 0.75, inverse_lerp(0, max_dist, x))


func blink_to(global_pos) -> void:
	global_position = global_pos
	stop()


func _set_offset(offset) -> void:
	sprite.offset.y = offset
	$Pivot/Sprite/HitBox.position.y = offset


func decide_target_pos(_possible_targets = get_possible_targets()):
	# Find best place to cast blizzard
	# Try casting on top of every target: O(n*n)
	var max_target_count = 0
	var best_target = null
	var _starting_point = global_position

	for main_target in _possible_targets:
		var cast_position = main_target.global_position
		var ct = 0
		if cast_position.distance_to(_starting_point) > get_cast_range():
			continue

		for target in _possible_targets:
			if cast_position.distance_to(target.global_position) <= get_radius():
				ct += 1

		if ct > max_target_count:
			max_target_count = ct
			best_target = main_target

	if best_target:
		return (best_target.global_position)
	return null


func get_possible_targets():
	return get_tree().get_nodes_in_group(CONFIG.ENEMY_GROUP)


func _set_radius(_rad):
	_radius = _rad
	hitBox.scale = Vector2.ONE * float(_radius / base_radius)
	return self


func get_radius() -> float:
	return _radius


func get_cast_range() -> float:
	return 280.0 # TODO: make dynamic


func get_total_damage():
	return CumulativeDamage.new([
		Damage.new().copy_from(damage)\
				.increased_by(get_owner().get_stat(StatContainer.STATS.BASE_DAMAGE))\
				.set_originator(get_owner()),
	])


func _damage_targets(targets) -> void:
	for target in targets:
		if target.has_method("take_damage"):
			var total = get_total_damage()
			target.take_damage(total)
			emit_signal("enemy_hit", target, total)
		else:
			push_warning("target cannot take damage")


### SIGNAL RESPONSES ###
func _on_landing() -> void:
	LOG.pr(LOG.LOG_TYPE.GAMEPLAY, "on spear landed")

	var areas = hitBox.get_areas_inside()
	var targets = UTILS.get_owners(areas)
	_damage_targets(targets)

	if false and P_LandVFX:
		var fx = P_LandVFX.instance()
#		GROUP.get_global(GROUP.BATTLE_WORLD).vfxContainer.add_child(fx)
		add_child(fx)
		fx.set_as_toplevel(true)
		fx.global_position = collision_shape.global_position
#		fx.global_scale = Vector2.ONE * (collision_shape.shape.radius / 450.0)
#		print (fx.global_scale)
		fx.emit()

	hide()
