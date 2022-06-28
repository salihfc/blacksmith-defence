extends Node2D
class_name Unit
"""
"""
### SIGNAL ###
signal _context_changed() # Internal signal
signal info_updated()

signal died()
signal low_life_reached()
signal selected()
signal life_fraction_updated(frac)

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
# Gameplay
const LOW_LIFE_FRACTION = 0.5

# Physics
const MAX_SOFTBODY_CALC = 5
const COLLISION_PUSH = 10.0

const KNOCKBACK_DAMPING = 0.9
const BASE_SPEED = 100.0

### EXPORT ###
export(Resource) var agent_brain = null # Type: Agent
export(NodePath) var NP_HpBar = null
export(NodePath) var NP_StateLabel = null
export(NodePath) var NP_ModListDisplay = null

### PUBLIC VAR ###
var grid_pos setget set_grid_pos, get_grid_pos
var default_state = STATE.IDLE

### PRIVATE VAR ###
var _stats = null
var _base_cost = null
var _enhance_cost = null

var _move_speed_modifiers = []
var _status_container = StatusEffectContainer.new()

var _velocity = Vector2.ZERO
var _knockback = Vector2.ZERO

var _state = default_state
var _under_mouse = false
var _target_weakref = null

## Triggered actions
var _on_hit_triggers = []
var _on_death_triggers = []
var _on_low_life_reached_triggers = []
# book-keeping for low_life_triggers
var _low_life_already_reached : bool = false

### ONREADY VAR ###
onready var hpBar = get_node(NP_HpBar) as AnimatedHpBar
onready var stateLabel = get_node(NP_StateLabel) as Label
onready var modListDisplay = get_node(NP_ModListDisplay) as ModListDisplay


onready var spriteParent = $SpriteParent as Node2D
onready var sprite = $SpriteParent/Sprite as Sprite
onready var animPlayer = $AnimationPlayer as AnimationPlayer
onready var weaponSlot = $SpriteParent/WeaponSlot as WeaponSlot
onready var spellSlot = $SpriteParent/SpellSlot as Node2D

# Areas
onready var softBody : ObjectArea = $SpriteParent/Areas/SoftBody as ObjectArea
onready var body : ObjectArea = $SpriteParent/Areas/Body as ObjectArea
onready var attackRange : ObjectArea = $SpriteParent/Areas/AttackRange as ObjectArea
onready var dustEffect = $VFXGroundDust

# Debug
onready var DBG_range_circle = $RangeCircle as RangeCircle

### VIRTUAL FUNCTIONS (_init ...) ###
func _to_string():
	return name


func _ready():
	_status_container.start(self)

	SIGNAL.bind(
		attackRange, "area_entered",
		self, "_on_enemy_entered_range",
		[1]
	)

	SIGNAL.bind_bulk(
		self, self,
		[
			["_context_changed", "_on_context_changed"],
			["died", "_on_death"],
			["low_life_reached", "_on_low_life_reached"]
		]
	)

	SIGNAL.bind(
		self, "life_fraction_updated",
		hpBar, "set_value_fraction"
	)

	hpBar.set_value_fraction(1.0)

	set_velocity(get_default_dir() * BASE_SPEED)
	call_deferred("decide")

	stateLabel.visible = CONFIG.SHOW_AI_STATE

	change_state(STATE.IDLE)


func _process(_delta):
# TEMPORARY FOR DEBUGGING PURPOSES
	if Input.is_action_just_pressed("left_click"):
		if _under_mouse:
			LOG.pr(LOG.LOG_TYPE.INPUT, "Unit [%s] selected with mouse" % [self])
			emit_signal("selected")


func _physics_process(delta):
	_knockback *= KNOCKBACK_DAMPING

	match _state:
		STATE.WALK:
			global_position += ((_velocity) + _knockback) * delta * get_stat(StatContainer.STATS.MOVE_SPEED) * (_get_move_speed_multiplier())
		_:
			global_position += (_knockback) * delta

### PUBLIC FUNCTIONS ###
# INIT func
func init_with_data(unit_recipe : UnitRecipe) -> void:
	var unit_data = unit_recipe.base_unit
	name = unit_data.name
	_stats = unit_data.copy_stats()
	_base_cost = unit_data.get_cost()
	_enhance_cost = unit_recipe.enhance_cost

	# Set hp to max
	_stats.set_stat(StatContainer.STATS.HP, get_stat(StatContainer.STATS.MAX_HP))

	# reference to sprite should be set in _ready
	assert(sprite)
	sprite.texture = unit_data.get_texture()
	sprite.scale *= unit_data.sprite_scale
	sprite.offset.y = -sprite.texture.get_height() / 2.0
	if unit_data.flip_h:
		sprite.flip_h = true

	assert(unit_data.get_stat(StatContainer.STATS.ATK_RANGE) != null)
	attackRange.set_radius(get_stat(StatContainer.STATS.ATK_RANGE))
	DBG_range_circle.radius = get_stat(StatContainer.STATS.ATK_RANGE)

	assert(unit_data.brain != null)
	agent_brain = unit_data.brain.duplicate(true)


func is_unit_in_attack_range(unit) -> bool:
	return unit in get_enemies_in_attack_range()


func is_unit_in_range(_unit) -> bool:
	return true # Todo: Fix


func set_grid_pos(pos : Vector2) -> void:
	grid_pos = pos


func add_mod(mod):
	modListDisplay.add_display_from_icon(mod.icon)
	return self


func add_on_hit_trigger(on_hit_trigger : Trigger):
	_on_hit_triggers.append(on_hit_trigger)
	return self


func add_on_death_trigger(on_death_trigger : Trigger):
	_on_death_triggers.append(on_death_trigger)
	return self


func add_to_stat(id : int, amount):
	assert(amount != null)
	_stats.set_stat(id, get_stat(id) + amount)


func multiply_stat(id : int, amount):
	assert(amount != null)
	_stats.set_stat(id, get_stat(id) * amount)


func apply_status_effect(status_effect):
	assert(status_effect is StatusEffect)
	status_effect.apply(_status_container, self)
	return self

# Getters
func get_stat(id : int, default = null):
	return _stats.get_stat(id, default)


func get_grid_pos() -> Vector2:
	return grid_pos


func get_info():
	return [self]


func get_utility_cache() -> Array:
	return agent_brain.get_eval_cache().as_array()


func get_default_dir():
	return Vector2.RIGHT


func get_state():
	return _state


func get_hp_fraction():
	return get_stat(StatContainer.STATS.HP) / get_stat(StatContainer.STATS.MAX_HP)


func get_damage():
	return get_stat(StatContainer.STATS.BASE_DAMAGE) * get_stat(StatContainer.STATS.DAMAGE_MULTI)


func get_enemies_in_attack_range() -> Array:
	return UTILS.get_owners(attackRange.get_overlapping_areas())


func normalized_distance_to_unit(unit) -> float:
	return _distance_to_another_unit(unit) / attackRange.get_radius()

"""
	AI ACTION DECISION & EXECUTION
"""
# Modifiers
func decide() -> void:
	var enemies_in_range = get_enemies_in_attack_range()
	var action = agent_brain.decide_action(CONFIG.context, self, enemies_in_range)
	LOG.pr(LOG.LOG_TYPE.AI, "[%s] : selected [%s]" % [self, action])

#	if animPlayer.current_animation == UTILS.get_enum_string_from_id(STATE, STATE.ATTACK).to_lower()\
#			and animPlayer.is_playing():
#		return
	execute_action(action)
	emit_signal("info_updated")


func execute_action(action) -> void:
	var action_type = action.action_type

	match action_type:
		IAUS.ACTION.WALK_TOWARDS_ENEMY_BASE:
			_action_walk_towards_enemy_base()

		IAUS.ACTION.ATTACK_ENEMY:
			_action_attack_enemy()

		IAUS.ACTION.IDLE:
			_action_idle()


func change_state(new_state):

	match new_state:
		STATE.ATTACK:
			if _target_weakref == null or _target_weakref.get_ref() == null:
				_target_weakref = weakref(_select_target())
			stateLabel.text = "atk"
			dustEffect.emit(false)

		STATE.IDLE:

			stateLabel.text = "idl"
			dustEffect.emit(false)

		STATE.WALK:
			stateLabel.text = "wlk"
			if !dustEffect.is_emitting():
				dustEffect.emit()

		_:
			dustEffect.emit(false)

	_state = new_state
	var anim_name = UTILS.get_enum_string_from_id(STATE, _state).to_lower()
	animPlayer.play(anim_name)


func set_velocity(vel : Vector2) -> void:
	_velocity = vel


func set_direction() -> void:
	spriteParent.scale.x = _velocity.x / abs(_velocity.x)


func apply_impulse(impulse : Vector2) -> void:
	# Disable y knockback
	LOG.pr(LOG.LOG_TYPE.PHYSICS, "[%s] IMPULSE applied [%s]" % [self, impulse])

	impulse.y = 0.0

	_knockback += impulse

# TODO: Carry Formulaic stuff into FORMULA class and clean other classes
func calc_final_damage_amount(_damage : Damage) -> float:
	var resist = get_stat(_damage.get_resist_type(), 0.0)
	var final_damage = _damage.get_amount()
	final_damage = FORMULA.get_resisted(final_damage, resist)
	return final_damage


func take_damage(_damage, pulse = Vector2.ZERO) -> void:
	assert(_damage)
	if _damage is CumulativeDamage:
		var n = _damage.get_pieces().size()
		for _damage_piece in _damage.get_pieces():
			take_damage(_damage_piece, pulse / n)
		return

	apply_impulse(pulse)
	var amount = calc_final_damage_amount(_damage)
	LOG.pr(LOG.LOG_TYPE.GAMEPLAY, "%s taking %s -> %s with kb [%s]" % [self, _damage, amount, pulse])

	add_to_stat(StatContainer.STATS.HP, -amount)

	if CONFIG.SHOW_FLOATING_DAMAGE_NUMBERS:
		FLOATING_TEXT.generate(global_position, str(amount)).set_text_color(_damage.get_text_color())

	TWEEN.interpolate_method_to_and_back(
		self, "set_shader_param_damage_flash_anim",
		0.0, 0.75,
		0.1, 0.05,
		rand_range(0.1, 0.2) # EXTRA JUICE EXPERIMENTAL
	)

	if get_stat(StatContainer.STATS.HP) <= 0.0:
		emit_signal("died")
		queue_free()
	else:

		if not _low_life_already_reached:
			var hp_frac = get_stat(StatContainer.STATS.HP) / get_stat(StatContainer.STATS.MAX_HP)
			if hp_frac <= LOW_LIFE_FRACTION:
				emit_signal("low_life_reached")
				_low_life_already_reached = true


		if CONFIG.SHOW_HP_BARS:
			emit_signal("life_fraction_updated", get_hp_fraction())


func set_shader_param_damage_flash_anim(x : float) -> void:
	sprite.material.set_shader_param("damage_flash_anim", x)


func set_target(new_target) -> void:
	assert(new_target)
	_target_weakref = weakref(new_target)


func attack() -> void:
	LOG.pr(LOG.LOG_TYPE.GAMEPLAY, "[%s] : Attacking [%s]" % [self, _target_weakref])
	if _target_weakref:
		var _target = _target_weakref.get_ref()
		if _target == null: # reselect target if previous one dies mid animation
			_target = _select_target()

		if _target: # make sure there are enemies around to attack
			_target.take_damage(Damage.new(Damage.TYPE.PHYSICAL, get_damage()))


func play_weapon_animation() -> void:
	if weaponSlot.has_weapon():
		weaponSlot.get_weapon().strike()


# TODO: Carry 'move speed mod' stuff into StatContainer class
func apply_move_speed_mod(mod) -> void:
	_move_speed_modifiers.append(mod)


func remove_move_speed_mod(mod) -> void:
	if _move_speed_modifiers.has(mod):
		_move_speed_modifiers.erase(mod)

### PRIVATE FUNCTIONS ###
func _select_target():
	var possible_targets = get_enemies_in_attack_range()
	return UTILS.get_closest_node(self, possible_targets)


func _set_area_layer_and_masks() -> void:
	pass # TODO: empty?


func _collision_update() -> void:
	var objects_inside = UTILS.get_owners(softBody.get_overlapping_areas())
	for i in range(min(MAX_SOFTBODY_CALC, objects_inside.size())):
		var object = objects_inside[i]
		var push_dir = global_position.direction_to(object.global_position)
		apply_impulse(-push_dir * COLLISION_PUSH)


func _get_move_speed_multiplier() -> float:
	var multi = 1.0
	for mod in _move_speed_modifiers:
		multi *= mod
	return multi


#####
##			OVERRIDABLE AI ACTIONS
#####
func _action_walk_towards_enemy_base():
	set_velocity(Vector2.LEFT * 100.0)
	change_state(STATE.WALK)


func _action_attack_enemy():
	LOG.pr(LOG.LOG_TYPE.AI, "%s ATTACKING!!" % [self])
	change_state(STATE.ATTACK)


func _action_idle():
	set_velocity(Vector2.ZERO)
	change_state(STATE.IDLE)


func _distance_to_another_unit(unit) -> float:
	return global_position.distance_to(unit.global_position)

### SIGNAL RESPONSES ###
func _on_context_changed() -> void:
	decide()


func _on_enemy_entered_range(_enemy_area, _range_type) -> void:
	if _state != STATE.ATTACK:
		emit_signal("_context_changed")


func _on_attack_ended() -> void:
	# TODO: (OPTIMIZE) Check if context changed for optimization
	emit_signal("_context_changed")


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"attack":
			_on_attack_ended()


func _on_death() -> void:
	for on_death_trigger in _on_death_triggers:
		on_death_trigger.execute(self)


func _on_low_life_reached() -> void:
	for low_life_trigger in _on_low_life_reached_triggers:
		low_life_trigger.execute(self)


# ui stuff
func _on_MousePickingArea_area_entered(_area):
	_under_mouse = true


func _on_MousePickingArea_area_exited(_area):
	_under_mouse = false
