extends Node2D

"""

"""

### SIGNAL ###
#signal base_hp_updated(hp, max_hp)
signal player_base_destroyed()

### ENUM ###


### CONST ###
const EnemyPrefab = preload("res://src/game/enemy/enemy.tscn")
const PlayerUnitPrefab = preload("res://src/game/player_units/player_unit.tscn")
const SPAWN_PERIOD = 4.0
const PLAYER_UNIT_MAX_Y_OFFSET = 20.0

const enemy_data = [
	preload("res://tres/enemies/enemy_skeleton.tres"),
]

### EXPORT ###
export(float) var player_base_max_hp

### PUBLIC VAR ###
var player_base_hp

### PRIVATE VAR ###


### ONREADY VAR ###
onready var spawnTimer = $SpawnTimer as Timer
onready var spawnPositions = $SpawnPositions as Node2D
onready var playerBase = $PlayerBase as Node2D

onready var units = $Units as Node2D

### VIRTUAL FUNCTIONS (_init ...) ###
func _ready():
	for base in playerBase.get_children():
# warning-ignore:unsafe_property_access
		CONFIG.context.lane_positions.append(base.global_position)
	
	player_base_hp = player_base_max_hp
	
#	call_deferred(
#		"emit_signal",
#		"base_hp_updated", player_base_max_hp, player_base_max_hp
#	)

	if CONFIG.SPAWN_ENEMIES:
		spawnTimer.start(SPAWN_PERIOD)


func _physics_process(_delta):
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
# warning-ignore:unsafe_property_access
		enemy.update_with_context(CONFIG.context)


### PUBLIC FUNCTIONS ###
func spawn_player_unit_with_item(_item, _lane) -> void:
	var new_unit = PlayerUnitPrefab.instance()
	units.add_child(new_unit)
	new_unit.give_item(_item)
	new_unit.global_position = get_global_mouse_position()
#	new_unit.global_position.x = playerBase.get_child(_lane).global_position.x


func spawn_enemy() -> void:
	var enemy = EnemyPrefab.instance()
	var lane = _get_random_spawn_idx()
	enemy.position = _get_lane_spawn_pos(lane)
	units.add_child(enemy)
	enemy.init_after_ready(_get_random_enemy_data())
	enemy.set_lane(lane)
	enemy.send_in_direction(Vector2.LEFT)
	
	UTILS.bind(
		enemy, "attacked_lane",
		self, "_on_enemy_attacked_lane",
		[lane]
	)


func damage_base(damage_amount : float) -> void:
	player_base_hp -= damage_amount

	if player_base_hp <= 0.0:
		emit_signal("player_base_destroyed")
#	else:
#		emit_signal("base_hp_updated", player_base_hp, player_base_max_hp)


### PRIVATE FUNCTIONS ###
func _get_random_enemy_data():
	return enemy_data[randi() % enemy_data.size()]


func _get_lane_spawn_pos(lane) -> Vector2:
	return spawnPositions.get_children()[lane].position


func _get_random_spawn_idx() -> Vector2:
	return randi() % spawnPositions.get_child_count()


### SIGNAL RESPONSES ###
func _on_SpawnTimer_timeout() -> void:
	spawn_enemy()
	spawnTimer.start(SPAWN_PERIOD)


func _on_enemy_attacked_lane(damage, _lane) -> void:
	damage_base(damage)
