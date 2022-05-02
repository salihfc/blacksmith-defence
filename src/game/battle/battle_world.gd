extends Node2D

"""

"""

### SIGNAL ###
#signal base_hp_updated(hp, max_hp)
signal player_base_destroyed()
signal unit_selected(unit)
signal material_collected(mat, count)

### ENUM ###


### CONST ###
const MaterialPrefab = preload("res://src/game/material/material.tscn")
const EnemyUnitPrefab = preload("res://src/game/unit/sub_units/enemy_unit.tscn")
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
onready var spawnPositions = $SpawnPositions as Node2D
onready var playerBase = $PlayerBase as Node2D

onready var units = $Units as Node2D
onready var spawnTimer = $SpawnTimer as Timer
onready var mousePointerArea = $MousePointerArea as ObjectArea

### VIRTUAL FUNCTIONS (_init ...) ###
func _ready():
	CONFIG.context.battle_world = self
	player_base_hp = player_base_max_hp
	
	UTILS.bind(
		spawnTimer, "timeout",
		self, "_on_SpawnTimer_timeout"
	)
#	spawnTimer.start(4.0)
	
#	call_deferred(
#		"emit_signal",
#		"base_hp_updated", player_base_max_hp, player_base_max_hp
#	)


func _physics_process(_delta):
	mousePointerArea.global_position = get_global_mouse_position()

	if Input.is_action_just_pressed("ui_up"):
		spawn_enemy()


	for i in range(1, 4):
		if Input.is_action_just_pressed("%s" % [i]):
			spawn_enemy(i-1)


### PUBLIC FUNCTIONS ###
func spawn_unit(unit : Unit) -> void:
	var lane = _get_random_spawn_idx()
	units.add_child(unit)
	unit.global_position = playerBase.get_child(lane).global_position + Vector2.RIGHT * 50.0

	UTILS.bind(
		unit, "selected",
		self, "_on_unit_selected",
		[unit]
	)


func spawn_enemy(lane = null) -> void:
	LOG.pr(1, "Spawning Enemy")
	var enemy = EnemyUnitPrefab.instance()
	units.add_child(enemy)
	enemy.init_with_data(preload("res://src/game/unit/default_enemy_unit_data.tres"))

	if lane == null:
		lane = _get_random_spawn_idx()
	enemy.position = _get_lane_spawn_pos(lane)

	UTILS.bind(
		enemy, "selected",
		self, "_on_unit_selected",
		[enemy]
	)
	
	UTILS.bind(
		enemy, "died",
		self, "_on_enemy_died",
		[enemy]
	)


func spawn_random_mat(spawn_pos) -> void:
	var material_data = load("res://tres/materials/material_iron.tres")
	var new_mat = MaterialPrefab.instance()
	new_mat.set_data(material_data, 2)
	
	units.add_child(new_mat)
	new_mat.global_position = spawn_pos
	new_mat.play_drop_animation()
	
	UTILS.bind(
		new_mat, "hovered",
		self, "_on_mat_hovered",
		[new_mat]
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


func _on_SpawnTimer_timeout():
	spawn_enemy()
	spawnTimer.start(4.0)


func _on_unit_selected(unit):
	emit_signal("unit_selected", unit)


func _on_enemy_died(enemy):
	# spawn random materials
	spawn_random_mat(enemy.global_position)


func _on_mat_hovered(mat):
	emit_signal("material_collected", mat.get_mat(), mat.get_count())
	mat.queue_free()
