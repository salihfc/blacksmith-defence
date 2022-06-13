extends Node2D
"""
"""
### SIGNAL ###
# raw input
signal left_button_clicked()
# input signals
signal unit_selected(unit)
signal material_collected(mat, count)
signal drag_grid_pos_changed(is_new_grid_pos_valid)
# gameplay signals
signal base_damaged(damage)
signal wave_completed()
signal unit_spawned(unit)

### ENUM ###
### CONST ###
# prefabs
const P_Material = preload("res://src/game/material/material.tscn")
const P_EnemyUnit = preload("res://src/game/unit/sub_units/enemy_unit.tscn")
const P_PlayerUnit = preload("res://src/game/unit/sub_units/player_unit.tscn")
const P_UnitHolo = preload("res://src/ui/unit_holo.tscn")
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
onready var gridTilemap = $BG/VisualTileMap as BaseTilemap

onready var mousePointerArea = $MousePointerArea as ObjectArea
onready var draggedItemSlot = $MousePointerArea/DraggedItemSlot as Node2D

onready var spawnPositions = $SpawnPositions as Node2D
onready var playerSpawnPositions =  $PlayerSpawnPositions as Area2D

onready var spawnTimer = $SpawnTimer as Timer

onready var vfxContainer = $Containers/VFXContainer as Node2D
onready var floatingTextContainer = $Containers/FloatingTextContainer as Node2D

onready var playerBase = $PlayerBase as Node2D
onready var units = $Units as Node2D
# Resource Containers
onready var grid_pos_cache = GridDataContainer.new()

### VIRTUAL FUNCTIONS (_init ...) ###
var _left_button_down = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and  event.button_index == BUTTON_LEFT:
		if event.pressed == true and _left_button_down == false: # Just pressed
				emit_signal("left_button_clicked")
		_left_button_down = event.pressed # Save as prev state


func _ready():
	# TODO: Looks bad
	CONFIG.context.set_world(self)

	# TODO: Maybe unnecessary?
	SIGNAL.bind(
		self, "left_button_clicked",
		self, "_on_left_button_clicked"
	)

	SIGNAL.bind(
		VFX, "vfx_created",
		self, "_on_vfx_created"
	)

	SIGNAL.bind(
		FLOATING_TEXT, "floating_text_created",
		self, "_on_floating_text_created"
	)

	for base in playerBase.get_children():
		SIGNAL.bind(
			base, "base_taken_damage",
			self, "damage_base"
		)

	SIGNAL.bind(
		mousePointerArea, "areas_inside_changed",
		self, "_on_mousePointerArea_areas_inside_changed"
	)

	if encounter:
		SIGNAL.bind_bulk(
			encounter, self,
			[
				["enemy_encountered", "spawn_enemy"],
				["wave_ended", "_on_wave_ended"],
			]
		)

		SIGNAL.bind(
			spawnTimer, "timeout",
			self, "_on_spawn_timer_timeout"
		)

	# Make sure materials show in the UI even if their amount is 0
	for mat in material_pool.get_materials():
		call_deferred("emit_signal", "material_collected", mat, 0)

	call_deferred("emit_signal", "material_collected",
		load("res://tres/materials/material_iron.tres"), 100)


func _physics_process(_delta):
	_set_mouse_pointer_area_pos()
	# Binding buttons [1, 2, 3] to manually spawn enemies in lanes
	for i in range(1, 4):
		if Input.is_action_just_pressed("%s" % [i]):
			spawn_enemy(_get_random_enemy_data(), i-1)


### PUBLIC FUNCTIONS ###
func start_next_wave() -> void:
	encounter.start_wave(_current_wave)
	_current_wave += 1
	spawnTimer.start(rand_range(MIN_SPAWN_DELAY, MAX_SPAWN_DELAY))


func spawn_unit(unit_data : UnitData, pos : Vector2) -> void:
	var unit = P_PlayerUnit.instance()
	units.add_child(unit)
	unit.global_position = pos
	unit.grid_pos = _get_mouse_grid_pos()
	grid_pos_cache.place_object(weakref(unit), _get_mouse_grid_pos())

	unit.init_with_data(unit_data)

	SIGNAL.bind(
		unit, "selected",
		self, "_on_unit_selected",
		[unit]
	)

	SIGNAL.bind(
		unit, "died",
		grid_pos_cache, "remove_object",
		[unit.grid_pos]
	)

	emit_signal("unit_spawned", unit_data)
	clear_dragged_item()


func spawn_enemy(enemy_data : UnitData, lane : int = _get_random_spawn_idx()) -> void:
	assert(enemy_data)
	var enemy = P_EnemyUnit.instance()
	units.add_child(enemy)
	enemy.init_with_data(enemy_data)
	LOG.pr(LOG.LOG_TYPE.GAMEPLAY, "Spawn Enemy (%s) with (%s) pow in [%s]" % [enemy_data, enemy_data.calc_power(), lane])

	enemy.position = _get_lane_spawn_pos(lane)

	SIGNAL.bind(
		enemy, "selected",
		self, "_on_unit_selected",
		[enemy]
	)

	SIGNAL.bind(
		enemy, "died",
		self, "_on_enemy_died",
		[enemy]
	)


func spawn_random_mat(spawn_pos) -> void:
	var material_data = load("res://tres/materials/material_iron.tres")
	var new_mat = P_Material.instance()
	new_mat.set_data(material_data, 2)

	units.call_deferred("add_child", new_mat)
	new_mat.global_position = spawn_pos
	new_mat.play_drop_animation()

	SIGNAL.bind(
		new_mat, "hovered",
		self, "_on_mat_hovered",
		[new_mat]
	)


func damage_base(damage : Damage) -> void:
	emit_signal("base_damaged", damage)


func set_dragged_item(drag_item_data) -> void:
	clear_dragged_item()
	_drag_item_data = drag_item_data

	var new_holo = P_UnitHolo.instance()
	new_holo.set_texture(drag_item_data.texture)
	draggedItemSlot.add_child(new_holo)

	SIGNAL.bind(
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
func _set_mouse_pointer_area_pos() -> void:
	mousePointerArea.global_position = get_global_mouse_position()
	if _drag_item_data: # Snap to grid if holding/dragging an item
		mousePointerArea.global_position = gridTilemap.get_center_of_cell_containing(mousePointerArea.global_position)

	if _get_mouse_grid_pos() != _prev_drag_grid_pos:
		_prev_drag_grid_pos = _get_mouse_grid_pos()
		emit_signal("drag_grid_pos_changed", _is_grid_pos_valid(_prev_drag_grid_pos))


func _is_grid_pos_valid(pos):
	return grid_pos_cache.is_pos_empty(pos) and mousePointerArea.get_areas_inside().size() > 0


func _get_mouse_grid_pos() -> Vector2:
	return gridTilemap.world_to_map(mousePointerArea.global_position)


func _get_dragged_item_holo():
	return draggedItemSlot.get_child(0) if draggedItemSlot.get_child_count() else null


func _get_random_enemy_data():
	return enemy_pool.get_random()


func _get_lane_spawn_pos(lane) -> Vector2:
	return spawnPositions.get_children()[lane].position + Vector2.UP * rand_range(-1.0, 1.0) * 40.0


func _get_random_spawn_idx() -> int:
	return randi() % spawnPositions.get_child_count()


### SIGNAL RESPONSES ###
# UI signal responses
func _on_left_button_clicked():
	LOG.pr(LOG.LOG_TYPE.INPUT, "battle_world action event: {left click pressed}")
	_set_mouse_pointer_area_pos() # Update mouse pointer area to guarantee sync
	# Left_click pressed put down dragged item if there is one
	var drag_item = get_drag_item_data()
	if drag_item:
		var areas = playerSpawnPositions.get_overlapping_areas()
		if areas.size():
			if not grid_pos_cache.is_occupied(_get_mouse_grid_pos()): # mouse is overlapping with spawn area
				spawn_unit(drag_item, mousePointerArea.global_position)
				clear_dragged_item()
			else:
				LOG.pr(LOG.LOG_TYPE.AI, "pos (%s) OCCUPIED" % [_get_mouse_grid_pos()])


func _on_unit_selected(unit):
	emit_signal("unit_selected", unit)


func _on_mat_hovered(mat):
	emit_signal("material_collected", mat.get_mat(), mat.get_count())


func _on_mousePointerArea_areas_inside_changed() -> void:
	var dragged_item_holo = _get_dragged_item_holo()
	if dragged_item_holo:
		if mousePointerArea.get_areas_inside().empty():
			dragged_item_holo.set_valid(false)
		elif not grid_pos_cache.is_occupied(_get_mouse_grid_pos()):
			dragged_item_holo.set_valid(true)

# Gameplay signal responses
func _on_enemy_died(enemy):
	# spawn random materials
	spawn_random_mat(enemy.global_position)
	VFX.generate_fx_at(VFX.FX.BLOOD_EXPLOSION_PARTICLES, enemy.global_position)


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
