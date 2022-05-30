extends Node2D
class_name Unit

"""

"""

### SIGNAL ###
signal died()
signal selected()

### ENUM ###
enum COLLISION {
	WORLD		= 0b00000000000000000001,
	PLAYER		= 0b00000000000000000100,
	PLAYER_BASE	= 0b00000000000000001000,

	ENEMY		= 0b00000000000000010000,

	MOUSE		= 0b00000000001000000000,
}

enum STATE {
	IDLE,
	WALK,
	ATTACK,
}

### CONST ###
const MAX_SOFTBODY_CALC = 5
const COLLISION_PUSH = 10.0

const KNOCKBACK_DAMPING = 0.9
const BASE_SPEED = 100.0
const BASE_DAMAGE = 20.0
### EXPORT ###
### PUBLIC VAR ###
var default_state = STATE.IDLE
### PRIVATE VAR ###
var _max_hp
var _hp
var _move_speed := 1.0
var _atk_speed := 1.0
var _damage_multi := 1.0
#
var _resist_phys := 0.0
var _resist_fire := 0.0
var _resist_water := 0.0
var _resist_earth := 0.0

var _velocity = Vector2.ZERO
var _knockback = Vector2.ZERO

var _state = default_state
var _under_mouse = false
var _target_weakref = null

# redundant?
var _sprite_texture

### ONREADY VAR ###
onready var spriteParent = $SpriteParent as Node2D
onready var sprite = $SpriteParent/Sprite as Sprite
onready var stateLabel = $DEBUG/StateLabel
onready var animPlayer = $AnimationPlayer as AnimationPlayer
onready var hpBar = $HpBar as Control
onready var weaponSlot = $SpriteParent/WeaponSlot as Node2D
onready var spellSlot = $SpriteParent/SpellSlot as Node2D

# Areas
onready var softBody : ObjectArea = $SpriteParent/Areas/SoftBody as ObjectArea
onready var body : ObjectArea = $SpriteParent/Areas/Body as ObjectArea
onready var attackRange : ObjectArea = $SpriteParent/Areas/AttackRange as ObjectArea 
onready var dustEffect = $VFXGroundDust

### VIRTUAL FUNCTIONS (_init ...) ###
func _ready():
	UTILS.bind(
		attackRange, "area_entered",
		self, "_on_enemy_entered_range",
		[1]
	)
	hpBar.set_value(1.0)
	
	set_velocity(get_default_dir() * BASE_SPEED)
	call_deferred("decide")

	stateLabel.visible = CONFIG.SHOW_AI_STATE



func _process(_delta):
# TEMPORARY FOR DEBUGGING PURPOSES
	if Input.is_action_just_pressed("left_click"):
		if _under_mouse:
			LOG.pr(1, "Unit [%s] selected with mouse" % [self])
			emit_signal("selected")


func _physics_process(delta):
	_knockback *= KNOCKBACK_DAMPING 

	match _state:
		STATE.WALK:
			global_position += ((_velocity) + _knockback) * delta * _move_speed
		_:
			global_position += (_knockback) * delta

#	_collision_update()


### PUBLIC FUNCTIONS ###
# INIT func
func init_with_data(unit_data : UnitData) -> void:
	_max_hp = unit_data.max_hp
	_hp = _max_hp
	#
	_atk_speed = unit_data.atk_speed
	animPlayer.set_speed_scale(_atk_speed)
	
	_move_speed = unit_data.move_speed
	_damage_multi = unit_data.damage_multi

	_resist_phys = unit_data.resist_phys
	_resist_fire = unit_data.resist_fire
	_resist_water = unit_data.resist_water
	_resist_earth = unit_data.resist_earth


	# reference to sprite should be set in _ready
	sprite.texture = unit_data.texture
	sprite.offset.y = -sprite.texture.get_height() / 2.0

	if unit_data.attack_range:
		attackRange.set_radius(unit_data.attack_range)


# Getters
func get_info():
	return [self]


func get_default_dir():
	return Vector2.RIGHT


func get_state():
	return _state


func get_hp_perc():
	return _hp / _max_hp


func get_damage():
	return BASE_DAMAGE * _damage_multi


func get_enemies_in_attack_range() -> Array:
	return UTILS.get_owners(attackRange.get_overlapping_areas())


# Modifiers
func decide() -> void:
	var enemies_in_range = get_enemies_in_attack_range()
	if enemies_in_range.size():
		change_state(STATE.ATTACK)
	else:
		change_state(default_state)


func change_state(new_state):
	
	match new_state:
		STATE.ATTACK:
			if _target_weakref == null or _target_weakref.get_ref() == null:
				_target_weakref = weakref(_select_target())
			animPlayer.play("attack")
			stateLabel.text = "atk"
			dustEffect.emit(false)

		STATE.IDLE:
			animPlayer.play("idle")
			stateLabel.text = "idl"
			dustEffect.emit(false)

		STATE.WALK:
			animPlayer.play("walk")
			stateLabel.text = "wlk"
			if !dustEffect.is_emitting():
				dustEffect.emit()
		
		_:
			dustEffect.emit(false)

	_state = new_state


func set_velocity(vel : Vector2) -> void:
	_velocity = vel


func set_direction() -> void:
	spriteParent.scale.x = _velocity.x / abs(_velocity.x)


func apply_impulse(impulse : Vector2) -> void:
	# Disable y knockback
	impulse.y = 0.0
	
	_knockback += impulse


func calc_final_damage_amount(_damage : Damage) -> float:
	var resist = 0.0
	match _damage.get_type():
		Damage.TYPE.PHYSICAL:
			resist = _resist_phys
		Damage.TYPE.FIRE:
			resist = _resist_fire
		Damage.TYPE.WATER:
			resist = _resist_water
		Damage.TYPE.EARTH:
			resist = _resist_earth

	var final_damage = _damage.get_amount()
	final_damage = FORMULA.get_resisted(final_damage, resist)
	return final_damage


func take_damage(_damage : Damage, pulse := Vector2.ZERO) -> void:
	apply_impulse(pulse)
	var amount = calc_final_damage_amount(_damage)
	LOG.pr(3, "%s taking %s -> %s" % [self, _damage, amount])
	_hp -= amount
	
	if CONFIG.SHOW_FLOATING_DAMAGE_NUMBERS:
		FLOATING_TEXT.generate(global_position, str(amount)).set_crit(randf() > 0.5)
	
	
	TWEEN.interpolate_method_to_and_back(
		self, "set_shader_param_damage_flash_anim",
		0.0, 0.75,
		0.1, 0.05
	)

	if _hp <= 0.0:
		emit_signal("died")
		queue_free()
	else:
		if CONFIG.SHOW_HP_BARS:
			hpBar.visible = (get_hp_perc() < 1.0)
			hpBar.set_value(get_hp_perc())


func set_shader_param_damage_flash_anim(x : float) -> void:
	sprite.material.set_shader_param("damage_flash_anim", x)


func attack() -> void:
	LOG.pr(3, "[%s] : Attacking [%s]" % [self, _target_weakref])
	if _target_weakref:
		var _target = _target_weakref.get_ref()
		if _target == null: # reselect target if previous one dies mid animation
			_target = _select_target()

		if _target: # make sure there are enemies around to attack
			_target.take_damage(Damage.new(Damage.TYPE.PHYSICAL, BASE_DAMAGE * _damage_multi))


func play_weapon_animation() -> void:
	if weaponSlot.get_child_count():
		weaponSlot.get_child(0).strike()


### PRIVATE FUNCTIONS ###
func _select_target():
	var possible_targets = get_enemies_in_attack_range()
	return UTILS.get_closest_node(self, possible_targets)


func _set_area_layer_and_masks() -> void:
	pass


func _collision_update() -> void:
	var objects_inside = UTILS.get_owners(softBody.get_overlapping_areas())
	for i in range(min(MAX_SOFTBODY_CALC, objects_inside.size())):
		var object = objects_inside[i]
		var push_dir = global_position.direction_to(object.global_position)
		apply_impulse(-push_dir * COLLISION_PUSH)


### SIGNAL RESPONSES ###
func _on_enemy_entered_range(_enemy_area, _range_type) -> void:
	if _state != STATE.ATTACK:
		LOG.pr(1, "[%s] CONTEXT CHANGED RETHINKING" % [self])
		decide()


func _on_attack_ended() -> void:
	decide()


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"attack":
			_on_attack_ended()



func _on_MousePickingArea_area_entered(_area):
	_under_mouse = true


func _on_MousePickingArea_area_exited(_area):
	_under_mouse = false
