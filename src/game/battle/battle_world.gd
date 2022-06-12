extends Node2D

"""

"""

### SIGNAL ###
signal base_damaged(damage)
signal wave_completed()
signal unit_selected(unit)
signal unit_spawned(unit)
signal material_collected(mat, count)
signal drag_grid_pos_changed(is_new_grid_pos_valid)
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
var _prev_drag_grid_pos = Vector2.ZERO
var paused = false

### ONREADY VAR ###
onready var bgTilemap = $BG/TileMap as TileMap
onready var gridTilemap = $BG/VisualTileMap as TileMap

onready var spawnPositions = $SpawnPositions as Node2D
onready var playerBase = $PlayerBase as Node2D
onready var spawnTimer = $SpawnTimer as Timer
onready var vfxContainer = $Containers/VFXContainer as Node2D
onready var floatingTextContainer = $Containers/FloatingTextContainer as Node2D

onready var units = $Units as Node2D
onready var mousePointerArea = $MousePointerArea as ObjectArea
onready var playerSpawnPositions =  $PlayerSpawnPositions as Area2D
onready var draggedItemSlot = $MousePointerArea/DraggedItemSlot as Node2D

# Resource Containers
onready var grid_pos_cache = GridDataContainer.new()

func _process(_delta):

	if Input.is_action_just_pressed("left_click"):
		_set_mouse_pointer_area_pos() # Update mouse pointer area to guarantee sync
		LOG.pr(LOG.LOG_TYPE.INPUT, "battle_world action event: {left click pressed}")
		# left_click Released
		var drag_item = get_drag_item_data()
		if drag_item:
			var areas = playerSpawnPositions.get_overlapping_areas()
			if areas.size():
				if not grid_pos_cache.is_occupied(_get_mouse_pointer_area_grid_pos()): # mouse is overlapping with spawn area
					spawn_unit(drag_item, mousePointerArea.global_position)
					clear_dragged_item()
				else:
					LOG.pr(LOG.LOG_TYPE.AI, "pos (%s) OCCUPIED" % [_get_mouse_pointer_area_grid_pos()])


### VIRTUAL FUNCTIONS (_init ...) ###
func _ready():
	CONFIG.context.set_world(self)

	UTILS.bind(
		VFX, "vfx_created",
		self, "_on_vfx_created"
	)
	UTILS.bind(
		FLOATING_TEXT, "floating_text_created",
		self, "_on_floating_text_created"
	)

	for base in playerBase.get_children():
		UTILS.bind(
			base, "base_taken_damage",
			self, "damage_base"
		)

	UTILS.bind(
		mousePointerArea, "areas_inside_changed",
		self, "_on_mousePointerArea_areas_inside_changed"
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


func _physics_process(_delta):
	_set_mouse_pointer_area_pos()

	for i in range(1, 4):
		if Input.is_action_just_pressed("%s" % [i]):
			spawn_enemy(_get_random_enemy_data(), i-1)


func _set_mouse_pointer_area_pos() -> void:
	if _drag_item_data:
		mousePointerArea.global_position = gridTilemap.map_to_world(gridTilemap.world_to_map(get_global_mouse_position()))\
				+ Vector2(gridTilemap.cell_size.x, gridTilemap.cell_size.y)/2.0
	else:
		mousePointerArea.global_position = get_global_mouse_position()

	if _get_mouse_pointer_area_grid_pos() != _prev_drag_grid_pos:
		_prev_drag_grid_pos = _get_mouse_pointer_area_grid_pos()
#		emit_signal("drag_grid_pos_changed", is_grid_pos_valid(_prev_drag_grid_pos))
		call_deferred("emit_signal", "drag_grid_pos_changed", is_grid_pos_valid(_prev_drag_grid_pos))


func is_grid_pos_valid(pos):
	return grid_pos_cache.is_pos_empty(pos) and mousePointerArea.get_areas_inside().size() > 0


func _get_mouse_pointer_area_grid_pos() -> Vector2:
	return gridTilemap.world_to_map(mousePointerArea.global_position)


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

	grid_pos_cache.place_object(weakref(unit), _get_mouse_pointer_area_grid_pos())
	unit.grid_pos = _get_mouse_pointer_area_grid_pos()

	UTILS.bind(
		unit, "selected",
		self, "_on_unit_selected",
		[unit]
	)

	UTILS.bind(
		unit, "died",
		grid_pos_cache, "remove_object",
		[unit.grid_pos]
	)

	emit_signal("unit_spawned", unit_data)
	clear_dragged_item()


func spawn_enemy(enemy_data, lane : int = _get_random_spawn_idx(), _ct : int = 1) -> void:
	LOG.pr(LOG.LOG_TYPE.GAMEPLAY, "SPAWN ENEMY [%s]" % [lane])
	if enemy_data == null:
		return
	var enemy = EnemyUnitPrefab.instance()
	units.add_child(enemy)
	enemy.init_with_data(enemy_data)

	LOG.pr(LOG.LOG_TYPE.GAMEPLAY, "Spawning Enemy (%s)(%s)" % [enemy, enemy_data.calc_power()])

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

#	if ct > 1:
#		spawn_enemy(enemy_data, null, ct-1)


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

	UTILS.bind(
		self, "drag_grid_pos_changed",
		new_holo, "set_valid"
	)

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
func get_dragged_item_holo():
	return draggedItemSlot.get_child(0) if draggedItemSlot.get_child_count() else null


func _get_random_enemy_data():
	return enemy_pool.get_random()


func _get_lane_spawn_pos(lane) -> Vector2:
	return spawnPositions.get_children()[lane].position + Vector2.UP * rand_range(-1.0, 1.0) * 40.0


func _get_random_spawn_idx() -> int:
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
	spawnTimer.stop()
	emit_signal("wave_completed")


func _on_spawn_timer_timeout() -> void:
	encounter.request_spawn_enemy()
	spawnTimer.start(rand_range(MIN_SPAWN_DELAY, MAX_SPAWN_DELAY))


func _on_vfx_created(vfx) -> void:
	vfxContainer.add_child(vfx)


func _on_floating_text_created(floating_text) -> void:
	floatingTextContainer.add_child(floating_text)


func _on_mousePointerArea_areas_inside_changed() -> void:
	var dragged_item_holo = get_dragged_item_holo()
	if dragged_item_holo:
		if mousePointerArea.get_areas_inside().empty():
			dragged_item_holo.set_valid(false)
		elif not grid_pos_cache.is_occupied(_get_mouse_pointer_area_grid_pos()):
			dragged_item_holo.set_valid(true)
