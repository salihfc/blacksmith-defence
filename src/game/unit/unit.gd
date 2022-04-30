extends Node2D
class_name Unit

"""

"""

### SIGNAL ###
signal died()

### ENUM ###
enum STATE {
	IDLE,
	WALK,
	WALK_TO_TARGET,
	ATTACK,
}

### CONST ###
const base_speed = 100.0
const base_damage = 20.0
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
var _max_hp
var _hp

var _velocity = Vector2.ZERO


var _agent
var _state = STATE.IDLE
# redundant?
var _sprite_texture

### ONREADY VAR ###
onready var sprite = $Sprite as Sprite
onready var stateLabel = $DEBUG/StateLabel
onready var animPlayer = $AnimationPlayer as AnimationPlayer
onready var hpBar = $HpBar as Control

# Areas
onready var body = $Areas/Body as Area2D
onready var aggroRange = $Areas/AggroRange as Area2D
onready var attackRange = $Areas/AttackRange as Area2D 


### VIRTUAL FUNCTIONS (_init ...) ###
func _ready():
	UTILS.bind(
		aggroRange, "area_entered",
		self, "_on_enemy_entered_range",
		[0]
	)
	UTILS.bind(
		attackRange, "area_entered",
		self, "_on_enemy_entered_range",
		[1]
	)

#	sprite.texture = _sprite_texture
	call_deferred("decide")
	
	$DebugShapes/AggroRangeCircle.radius = aggroRange.get_child(0).shape.radius
	$DebugShapes/AttackRangeCircle.radius = attackRange.get_child(0).shape.radius
	hpBar.set_value(1.0)


func _physics_process(delta):

	match _state:
		STATE.WALK:
			global_position += _velocity * delta
			stateLabel.text = "wlk"

		STATE.ATTACK:
			stateLabel.text = "atk"

		STATE.IDLE:
			stateLabel.text = "idl"

		STATE.WALK_TO_TARGET:
			stateLabel.text = "wltar"

		_:
			stateLabel.text = "!!!"


### PUBLIC FUNCTIONS ###
func init_with_data(_unit_data : UnitData) -> void:
	_max_hp = _unit_data.max_hp
	_hp = _max_hp
	
	# reference to sprite should be set in _ready
	sprite.texture = _unit_data.texture


# Getters
func get_state():
	return _state


func get_hp_perc():
	return _hp / _max_hp


func get_aggro_range():
	return aggroRange.get_child(0).shape.radius


func get_attack_range():
	return attackRange.get_child(0).shape.radius


func get_closest_enemy_dist_in_aggro_range_normalized() -> float:
	var enemies = get_enemies_in_aggro_range()
	if enemies.size() == 0:
		return 2.0

	var enemy_dist = get_aggro_range()
	for enemy in enemies:
		enemy_dist = min(enemy_dist, global_position.distance_to(enemy.global_position))
	return enemy_dist / get_aggro_range()


func get_closest_enemy_dist_in_attack_range_normalized() -> float:
	var enemies = get_enemies_in_attack_range()
	if enemies.size() == 0:
		return 2.0
	
	var enemy_dist = get_attack_range()
	for enemy in enemies:
		var t = global_position.distance_to(enemy.global_position)
		enemy_dist = min(enemy_dist, t)
	return enemy_dist / get_attack_range()


func get_enemies_in_aggro_range() -> Array:
	return UTILS.get_parents(UTILS.get_parents(aggroRange.get_overlapping_areas()))


func get_enemies_in_attack_range() -> Array:
#	var overlapping_areas = 
	return UTILS.get_parents(UTILS.get_parents(attackRange.get_overlapping_areas()))


# Modifiers
func set_velocity(vel : Vector2) -> void:
	_velocity = vel


func apply_impulse(impulse : Vector2) -> void:
	_velocity += impulse


func change_state(new_state):
	_state = new_state


func take_damage(_damage : Damage) -> void:
	LOG.pr(3, "[%s] taking %s" % [self, _damage])
	_hp -= _damage._amount
	
	if _hp <= 0.0:
		emit_signal("died")
		queue_free()
	else:
		hpBar.set_value(get_hp_perc())



func attack(_target : Unit) -> void:
	LOG.pr(3, "[%s] : Attacking [%s]" % [self, _target])
	if _target:
		_target.take_damage(Damage.new(Damage.TYPE.PHYSICAL, base_damage))
		


func decide():
	var action = _agent.decide_action(CONFIG.context, self, get_enemies_in_aggro_range())
	action.execute(CONFIG.context, self)


### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
func _on_enemy_entered_range(_enemy_area, _range_type) -> void:
	if _state != STATE.ATTACK:
		LOG.pr(1, "[%s] CONTEXT CHANGED RETHINKING" % [self])
		decide()


func _on_attack_ended() -> void:
	animPlayer.play("walk")
	decide()


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"attack":
			_on_attack_ended()
