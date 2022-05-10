extends Node2D

"""

"""

### SIGNAL ###
signal base_damaged(damage)
signal wave_completed()
signal unit_selected(unit)
signal unit_spawned(unit)
signal material_collected(mat, count)

### ENUM ###


### CONST ###
const MaterialPrefab = preload("res://src/game/material/material.tscn")
const EnemyUnitPrefab = preload("res://src/game/unit/sub_units/enemy_unit.tscn")
const PlayerUnitPrefab = preload("res://src/game/unit/sub_units/player_unit.tscn")
const UnitHoloPrefab = preload("res://src/ui/unit_holo.tscn")
### EXPORT ###
export(float) var MIN_SPAWN_DELAY = 0.5
export(float) var MAX_SPAWN_DELAY = 2.0

export(Resource) var enemy_pool = null
export(Resource) var material_pool = null
export(Resource) var encounter = null

### PUBLIC VAR ###

### PRIVATE VAR ###
var _current_wave = 0
var _drag_item_data = null


### ONREADY VAR ###
onready var bgTilemap = $BG/TileMap as TileMap
onready var gridTilemap = $BG/VisualTileMap as TileMap

onready var spawnPositions = $SpawnPositions as Node2D
onready var playerBase = $PlayerBase as Node2D
onready var spawnTimer = $SpawnTimer as Timer
onready var vfxContainer = $VFXContainer as Node2D

onready var units = $Units as Node2D
onready var mousePointerArea = $MousePointerArea as ObjectArea
onready var playerSpawnPositions =  $PlayerSpawnPositions as Area2D
onready var draggedItemSlot = $MousePointerArea/DraggedItemSlot as Node2D


func _process(_delta):
	
	if Input.is_action_just_pressed("left_click"):
		LOG.pr(1, "battle_world action event: {left click pressed}")
		# left_click Released 
		var drag_item = get_drag_item_data()
		if drag_item:
			var areas = playerSpawnPositions.get_overlapping_areas()
			if areas.size(): # mouse is overlapping
				spawn_unit(drag_item, mousePointerArea.global_position)
				clear_dragged_item()


### VIRTUAL FUNCTIONS (_init ...) ###
func _ready():
	UTILS.bind(
		VFX, "vfx_created",
		self, "_on_vfx_created"
	)

	CONFIG.context.set_world(self)

	for base in playerBase.get_children():
		UTILS.bind(
			base, "base_taken_damage",
			self, "damage_base"
		)


#signal encounter_completed()
	if encounter:
		UTILS.bind(
			encounter, "enemy_summoned",
			self, "spawn_enemy"
		)

		UTILS.bind(
			encounter, "wave_ended",
			self, "_on_wave_ended"
		)

		UTILS.bind(
			spawnTimer, "timeout",
			self, "_on_spawn_timer_timeout"
		)

	for mat in material_pool.get_materials():
		call_deferred("emit_signal",
				"material_collected",
				mat,
				0)
	
	call_deferred("emit_signal",
			"material_collected",
			load("res://tres/materials/material_iron.tres"),
			100)


#	spawnTimer.start(4.0)
	
#	call_deferred(
#		"emit_signal",
#		"base_hp_updated", player_base_max_hp, player_base_max_hp
#	)


func _physics_process(_delta):
	
	if _drag_item_data:
		mousePointerArea.global_position = gridTilemap.map_to_world(gridTilemap.world_to_map(get_global_mouse_position()))\
				+ Vector2(gridTilemap.cell_size.x, gridTilemap.cell_size.y)/2.0
	else:
		mousePointerArea.global_position = get_global_mouse_position()

	for i in range(1, 4):
		if Input.is_action_just_pressed("%s" % [i]):
			spawn_enemy(i-1)


### PUBLIC FUNCTIONS ###
func start_next_wave() -> void:
#	yield(get_tree().create_timer(1.0), "timeout")
	encounter.start_wave(_current_wave)
	_current_wave += 1

	spawnTimer.start(rand_range(MIN_SPAWN_DELAY, MAX_SPAWN_DELAY))


func spawn_unit(unit_data : UnitData, pos : Vector2 ) -> void:
	var unit = PlayerUnitPrefab.instance()
	units.add_child(unit)
	unit.global_position = pos
	unit.init_with_data(unit_data)

	UTILS.bind(
		unit, "selected",
		self, "_on_unit_selected",
		[unit]
	)
	
	emit_signal("unit_spawned", unit_data)
	clear_dragged_item()


func spawn_enemy(enemy_data, lane = null) -> void:
	if enemy_data == null:
		return
	LOG.pr(1, "Spawning Enemy")
	var enemy = EnemyUnitPrefab.instance()
	units.add_child(enemy)
	enemy.init_with_data(enemy_data)

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
	
	units.call_deferred("add_child", new_mat)
	new_mat.global_position = spawn_pos
	new_mat.play_drop_animation()
	
	UTILS.bind(
		new_mat, "hovered",
		self, "_on_mat_hovered",
		[new_mat]
	)


func damage_base(damage : Damage) -> void:
	emit_signal("base_damaged", damage)



func set_dragged_item(drag_item_data) -> void:
	clear_dragged_item()

	_drag_item_data = drag_item_data
	var new_holo = UnitHoloPrefab.instance()
	new_holo.set_texture(drag_item_data.texture)
	draggedItemSlot.add_child(new_holo)
	playerSpawnPositions.show()
	gridTilemap.show()


func get_drag_item_data():
	return _drag_item_data


func clear_dragged_item() -> void:
	UTILS.clear_children(draggedItemSlot)
	_drag_item_data = null
	playerSpawnPositions.hide()
	gridTilemap.hide()


### PRIVATE FUNCTIONS ###
func _get_random_enemy_data():
	return enemy_pool.get_random()


func _get_lane_spawn_pos(lane) -> Vector2:
	return spawnPositions.get_children()[lane].position


func _get_random_spawn_idx() -> Vector2:
	return randi() % spawnPositions.get_child_count()


### SIGNAL RESPONSES ###


func _on_unit_selected(unit):
	emit_signal("unit_selected", unit)


func _on_enemy_died(enemy):
	# spawn random materials
	spawn_random_mat(enemy.global_position)
	VFX.generate_fx_at(VFX.FX.BLOOD_EXPLOSION_PARTICLES, enemy.global_position)


func _on_mat_hovered(mat):
	emit_signal("material_collected", mat.get_mat(), mat.get_count())


func _on_wave_ended(_wave_idx):
	emit_signal("wave_completed")


func _on_spawn_timer_timeout() -> void:
	encounter.request_spawn_enemy()
	spawnTimer.start(rand_range(MIN_SPAWN_DELAY, MAX_SPAWN_DELAY))


func _on_vfx_created(vfx) -> void:
	vfxContainer.add_child(vfx)
