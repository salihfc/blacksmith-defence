extends Node2D
class_name Unit

"""

"""

### SIGNAL ###


### ENUM ###
enum STATE {
	IDLE,
	WALK,
	WALK_TO_TARGET,
	ATTACK,
}

### CONST ###
const DECIDE_PERIOD = 1.0
const base_speed = 100.0

### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
var _max_hp
var _hp

var _velocity = Vector2.ZERO


var _decider
var _state = STATE.IDLE
# redundant?
var _sprite_texture

### ONREADY VAR ###
onready var sprite = $Sprite as Sprite
onready var stateLabel = $DEBUG/StateLabel
onready var decideTimer = $DecideTimer as Timer
onready var animPlayer = $AnimationPlayer as AnimationPlayer

# Areas
onready var body = $Areas/Body as Area2D
onready var aggroRange = $Areas/AggroRange as Area2D
onready var attackRange = $Areas/AttackRange as Area2D 


### VIRTUAL FUNCTIONS (_init ...) ###
func _ready():
	UTILS.bind(
		decideTimer, "timeout",
		self, "_on_DecideTimer_timeout"
	)
	
	call_deferred("_on_DecideTimer_timeout")
#	decideTimer.start(DECIDE_PERIOD)

	sprite.texture = _sprite_texture


func _physics_process(delta):
	
	match _state:
		STATE.WALK:
			global_position += _velocity * delta


### PUBLIC FUNCTIONS ###
func get_state():
	return _state


func init_with_data(_unit_data : UnitData) -> void:
	_max_hp = _unit_data.max_hp
	_hp = _max_hp
	_sprite_texture = _unit_data.texture


func take_damage(_damage : Damage) -> void:
	LOG.pr(3, "[%s] taking %s" % [self, _damage])


func attack(_target = null) -> void:
	LOG.pr(3, "[%s] : Attacking [%s]" % [self, _target])


func enemies_in_aggro_range() -> Array:
	return UTILS.get_parents(aggroRange.get_overlapping_areas())


func enemies_in_attack_range() -> Array:
	return UTILS.get_parents(attackRange.get_overlapping_areas())


func execute_command(_command : Command) -> void:
	match _command.type:
		Command.TYPE.WALK:
			_velocity = _command.args[0].normalized() * base_speed
			_state = STATE.WALK
			animPlayer.play("walk")

		Command.TYPE.ATTACK:
			_state = STATE.ATTACK
			attack()
		Command.TYPE.IDLE:
			_state = STATE.IDLE
			animPlayer.play("idle")


### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
func _on_DecideTimer_timeout():
	var command = _decider.decide(self, CONFIG.context)
	execute_command(command)
	decideTimer.start(DECIDE_PERIOD)


func _on_attack_ended() -> void:
	animPlayer.play("walk")
	_on_DecideTimer_timeout()


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"attack":
			_on_attack_ended()
