extends Node2D

"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###
const EnemyPrefab = preload("res://src/game/enemy/enemy.tscn")

const SPAWN_PERIOD = 4.0

const enemy_data = [
	preload("res://tres/enemies/enemy_skeleton.tres"),
]

### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###
onready var spawnTimer = $SpawnTimer as Timer
onready var spawnPositions = $SpawnPositions as Node2D
onready var enemyContainer = $EnemyContainer as Node2D

### VIRTUAL FUNCTIONS (_init ...) ###
func _ready():
	if CONFIG.SPAWN_ENEMIES:
		spawnTimer.start(SPAWN_PERIOD)



### PUBLIC FUNCTIONS ###
func spawn_enemy() -> void:
	var enemy = EnemyPrefab.instance()
	enemy.position = _get_random_spawn_pos()
	enemyContainer.add_child(enemy)
	enemy.init_after_ready(_get_random_enemy_data())
	enemy.send_in_direction(Vector2.LEFT)


### PRIVATE FUNCTIONS ###
func _get_random_enemy_data():
	return enemy_data[randi() % enemy_data.size()]


func _get_random_spawn_pos() -> Vector2:
	return spawnPositions.get_children()[randi() % spawnPositions.get_child_count()].position

### SIGNAL RESPONSES ###


func _on_SpawnTimer_timeout():
	spawn_enemy()
	spawnTimer.start(SPAWN_PERIOD)
