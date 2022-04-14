extends Node2D

"""

"""

### SIGNAL ###
signal attacked_lane(damage)
signal died()

### ENUM ###
enum STATE {
	MOVING,
	ATTACKING,
}

### CONST ###
const MAX_Y_OFFSET = 24

const MAX_ATTACK_RANGE = 100
const ATTACK_RANGE = 60
const SLOWDOWN = 0.98

const ATTACK_CD = 1.0
### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###
var _max_hp
var _hp
var _damage
var _speed
var _velocity

var _lane
var _state

### ONREADY VAR ###
onready var sprite = $Sprite as Sprite
onready var attackCdTimer = $AttackCdTimer as Timer
onready var animPlayer = $AnimationPlayer as AnimationPlayer

### VIRTUAL FUNCTIONS (_init ...) ###
func _ready():
	add_to_group("enemy")
	_state = STATE.MOVING


func _physics_process(delta):
	global_position += _velocity * delta * _speed


### PUBLIC FUNCTIONS ###
func update_with_context(context) -> void:
	
	match _state:
		STATE.MOVING:
			if (global_position.distance_to(context.lane_positions[_lane])) < ATTACK_RANGE:
				_velocity = Vector2.ZERO
				_state = STATE.ATTACKING
				animPlayer.play("attack")
				LOG.pr(1, "[%s] starting to attack" % [self])
			elif (global_position.distance_to(context.lane_positions[_lane])) < MAX_ATTACK_RANGE:
				_velocity = _velocity.normalized() * (_velocity.length()) * SLOWDOWN


func init_after_ready(enemy_data) -> void:
	_max_hp = enemy_data.max_hp
	_hp = _max_hp
	_damage = enemy_data.damage
	_speed = enemy_data.speed
	sprite.texture = enemy_data.texture


func set_lane(lane : int) -> void:
	_lane = lane


func send_in_direction(dir : Vector2) -> void:
	position.y += rand_range(-MAX_Y_OFFSET, MAX_Y_OFFSET)
	_velocity = dir.normalized()


func take_damage(damage : float) -> void:
	_hp -= damage
	if _hp <= 0.0:
		emit_signal("died")
		queue_free()


### PRIVATE FUNCTIONS ###
func _deal_damage() -> void:
	emit_signal("attacked_lane", _damage)


### SIGNAL RESPONSES ###
func _on_AnimationPlayer_animation_finished(anim_name):
	
	match anim_name:
		"attack":
			attackCdTimer.start(ATTACK_CD)


func _on_AttackCdTimer_timeout():
	
	if _state == STATE.ATTACKING:
		animPlayer.play("attack")
