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
	add_to_group(CONFIG.ENEMY_GROUP)
	default_state = STATE.WALK

### PUBLIC FUNCTIONS ###
func init_with_data(unit_recipe : UnitRecipe) -> void:
	.init_with_data(unit_recipe)
	DBG_range_circle.modulate = Color.red
	DBG_range_circle.modulate.a = 0.1


func get_default_dir():
	return Vector2.LEFT


func set_direction() -> void:
	spriteParent.scale.x = -_velocity.x / abs(_velocity.x)

### PRIVATE FUNCTIONS ###
func _set_area_layer_and_masks() -> void:
	body.collision_layer = COLLISION.ENEMY
	attackRange.collision_mask = COLLISION.PLAYER | COLLISION.PLAYER_BASE

### SIGNAL RESPONSES ###
