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
func _set_area_layer_and_masks() -> void:
	body.collision_layer = COLLISION.ENEMY
	attackRange.collision_mask = COLLISION.PLAYER | COLLISION.PLAYER_BASE


### SIGNAL RESPONSES ###
