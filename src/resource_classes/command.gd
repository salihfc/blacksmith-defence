extends Resource
class_name Command
"""
"""
### SIGNAL ###
### ENUM ###
enum TYPE {
	IDLE,
	WALK,
	ATTACK,
}

### CONST ###
### EXPORT ###
export(int) var type = TYPE.IDLE

### PUBLIC VAR ###
### PRIVATE VAR ###
var args := []

### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _init(_type = TYPE.IDLE, _args := []):
	type = _type
	args = _args

### PUBLIC FUNCTIONS ###
### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
