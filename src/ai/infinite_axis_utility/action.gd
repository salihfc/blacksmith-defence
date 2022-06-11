extends IAUSObject
class_name Action

"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###


### EXPORT ###
export(Array, Resource) var _considerations = []
export(IAUS.ACTION) var action_type = IAUS.ACTION.IDLE

### PUBLIC VAR ###
var target = null


### PRIVATE VAR ###

### ONREADY VAR ###


### VIRTUAL FUNCTIONS (_init ...) ###


### PUBLIC FUNCTIONS ###
func score(context, actor, _target = null, base : float = 1.0) -> float:
	for axis in _considerations:
		var axis_score = axis.utility(context, actor, _target)
		base *= axis_score
	
	# normalization
	return pow(base, 1.0/_considerations.size()) 


# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
#func execute(context, actor) -> void:
#	match action_type:
#		IAUS.ACTION.WALK_TOWARDS_ENEMY_BASE:
#			actor.animPlayer.play("walk")
#			actor.set_velocity(Vector2.LEFT * 100.0)
#			actor.change_state(Unit.STATE.WALK)
#
#		IAUS.ACTION.ATTACK_ENEMY:
#			LOG.pr(LOG.LOG_TYPE.AI, "%s ATTACKING!!" % [actor])
#			actor.animPlayer.play("attack")
#			actor.change_state(Unit.STATE.ATTACK)
#			actor.attack(target)
#
#		IAUS.ACTION.IDLE:
#			actor.animPlayer.play("idle")
#			actor.set_velocity(Vector2.ZERO)
#			actor.change_state(Unit.STATE.IDLE)


### PRIVATE FUNCTIONS ###
func _to_string():
	return resource_path.get_file()

### SIGNAL RESPONSES ###
