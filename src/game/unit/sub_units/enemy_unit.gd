extends Unit
class_name EnemyUnit

"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###


### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###




### VIRTUAL FUNCTIONS (_init ...) ###
func _ready():
	default_state = STATE.WALK



### PUBLIC FUNCTIONS ###
func get_default_dir():
	return Vector2.LEFT


func set_direction() -> void:
	spriteParent.scale.x = -_velocity.x / abs(_velocity.x)


### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###