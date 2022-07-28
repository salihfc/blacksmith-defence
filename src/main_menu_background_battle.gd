extends Node2D
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(PackedScene) var P_EnemyUnit
export(Resource) var unit_pool
export(bool) var spawn_enemies

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
onready var units = $Units as YSort
onready var spawn_points = $EnemySpawnPoints as Node2D
onready var vfxContainer = $Containers/VFXContainer as Node2D
onready var floatingTextContainer = $Containers/FloatingTextContainer as Node2D

func _ready() -> void:
	add_to_group(str(GROUP.BATTLE_WORLD))
	for _i in 10:
		__spawn()

### PUBLIC FUNCTIONS ###
func spawn_enemy_at_pos(enemy_data : UnitData, pos : Vector2):
	assert(enemy_data)
	var enemy_recipe = UnitRecipe.new(enemy_data, null)
	var enemy = P_EnemyUnit.instance()
	units.add_child(enemy)
	enemy.init_with_data(enemy_recipe)
	enemy.global_position = pos
	return self

### PRIVATE FUNCTIONS ###
func spawn_random_mat_drop(_pos):
	return

func __spawn():
	if spawn_enemies:
		spawn_enemy_at_pos(
			unit_pool.get_random(),
			spawn_points.get_child(randi() % spawn_points.get_child_count()).global_position
		)

### SIGNAL RESPONSES ###

func _on_SpawnTimer_timeout() -> void:
	__spawn()
