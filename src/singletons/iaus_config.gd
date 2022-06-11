extends Node

"""

"""

### SIGNAL ###
### ENUM ###
enum INPUT {
	NONE,

	HP_PERC,
	ENEMY_IN_RANGE,
	ENEMY_IN_ATTACK_RANGE,
}

enum ACTION {
	IDLE, # Do nothing
	WALK_TOWARDS_ENEMY_BASE,
	WALK_TOWARDS_ENEMY,
	ATTACK_ENEMY,
}

### CONST ###
const NULL = -1.0

const _ACTION_NAMES = {
	ACTION.IDLE : "idle",
	ACTION.WALK_TOWARDS_ENEMY : "walk_towards_enemy",
	ACTION.WALK_TOWARDS_ENEMY_BASE : "walk_towards_enemy_base",
	ACTION.ATTACK_ENEMY : "attack",
}

### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func get_action_name(type : int):
	return _ACTION_NAMES.get(type)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
