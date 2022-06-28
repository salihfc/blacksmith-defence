extends Unit
class_name EnemyUnit
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(float) var drop_chance = 0.5

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

	var unit_data = unit_recipe.base_unit as UnitData
	if unit_data.enhancements:
		for enh in unit_data.enhancements:
			enh.call_deferred("apply_to", self)


func get_default_dir():
	return Vector2.LEFT


func set_direction() -> void:
	spriteParent.scale.x = -_velocity.x / abs(_velocity.x)

### PRIVATE FUNCTIONS ###
func _set_area_layer_and_masks() -> void:
	body.collision_layer = COLLISION.ENEMY
	attackRange.collision_mask = COLLISION.PLAYER | COLLISION.PLAYER_BASE

### SIGNAL RESPONSES ###
func _on_death() -> void:
	if UTILS.check(drop_chance):
		var battle_world = get_tree().get_nodes_in_group("battle_world")
		assert (battle_world.size() <= 1)

		if battle_world.size() == 1:
			battle_world[0].spawn_random_mat(global_position)

	._on_death()
