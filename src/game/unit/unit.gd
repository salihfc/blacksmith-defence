extends Node2D
class_name Unit

"""

"""

### SIGNAL ###
signal died()
signal selected()

### ENUM ###
enum STATE {
	IDLE,
	WALK,
	ATTACK,
}

### CONST ###
const base_speed = 100.0
const base_damage = 20.0
### EXPORT ###
### PUBLIC VAR ###
var default_state = STATE.IDLE
### PRIVATE VAR ###
var _max_hp
var _hp

var _velocity = Vector2.ZERO

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

# Areas
onready var body = $Areas/Body as Area2D
onready var attackRange = $Areas/AttackRange as Area2D 


### VIRTUAL FUNCTIONS (_init ...) ###
func _ready():
	UTILS.bind(
		attackRange, "area_entered",
		self, "_on_enemy_entered_range",
		[1]
	)
	hpBar.set_value(1.0)
	
	set_velocity(get_default_dir() * base_speed)
	call_deferred("decide")


func _process(_delta):
# TEMPORARY FOR DEBUGGING PURPOSES
	if Input.is_action_just_pressed("left_click"):
		if _under_mouse:
			LOG.pr(1, "Unit [%s] selected with mouse" % [self])
			emit_signal("selected")


func _physics_process(delta):
	match _state:
		STATE.WALK:
			global_position += _velocity * delta
			stateLabel.text = "wlk"


### PUBLIC FUNCTIONS ###
# INIT func
func init_with_data(_unit_data : UnitData) -> void:
	_max_hp = _unit_data.max_hp
	_hp = _max_hp
	
	# reference to sprite should be set in _ready
	sprite.texture = _unit_data.texture


# Getters
func get_info():
	return [self]


func get_default_dir():
	return Vector2.RIGHT


func get_state():
	return _state


func get_hp_perc():
	return _hp / _max_hp


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

		STATE.IDLE:
			animPlayer.play("idle")
			stateLabel.text = "idl"

		STATE.WALK:
			animPlayer.play("walk")
			stateLabel.text = "wlk"


	_state = new_state


func set_velocity(vel : Vector2) -> void:
	_velocity = vel


func set_direction() -> void:
	spriteParent.scale.x = _velocity.x / abs(_velocity.x)


func apply_impulse(impulse : Vector2) -> void:
	_velocity += impulse


func take_damage(_damage : Damage) -> void:
	LOG.pr(3, "[%s] taking %s" % [self, _damage])
	_hp -= _damage._amount
	
	if _hp <= 0.0:
		emit_signal("died")
		queue_free()
	else:
		hpBar.visible = (get_hp_perc() < 1.0)
		hpBar.set_value(get_hp_perc())


func attack() -> void:
	LOG.pr(3, "[%s] : Attacking [%s]" % [self, _target_weakref])
	if _target_weakref:
		var _target = _target_weakref.get_ref()
		if _target == null: # reselect target if previous one dies mid animation
			_target = _select_target()

		if _target: # make sure there are enemies around to attack
			_target.take_damage(Damage.new(Damage.TYPE.PHYSICAL, base_damage))


### PRIVATE FUNCTIONS ###
func _select_target():
	var possible_targets = get_enemies_in_attack_range()
	return UTILS.get_closest_node(self, possible_targets)


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
