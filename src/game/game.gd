extends Control
"""
"""
### SIGNAL ###
signal material_used(mat, count)

### ENUM ###
### CONST ###
# Prefabs
const P_UnitView = preload("res://src/game/unit_list_unit_view.tscn")

### EXPORT ###
"""
	NOTE:
	Only export NodePaths when the scene structure has a high depth to prevent
	very long, ugly looking paths after '$'
"""
export(NodePath) var NP_Battle
export(NodePath) var NP_MaterialList
export(NodePath) var NP_UnitList
export(NodePath) var NP_DebugWindow
export(NodePath) var NP_StartButton
export(NodePath) var NP_BaseHealthBar

export(Resource) var unit_data_pool = null
export(Resource) var player_base = null

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
onready var battle = get_node(NP_Battle)
onready var materialList = get_node(NP_MaterialList)
onready var unitList = get_node(NP_UnitList)
onready var debugWindow = get_node(NP_DebugWindow) as DebugWindow
onready var startWaveButton = get_node(NP_StartButton)
onready var baseHealthBar = get_node(NP_BaseHealthBar)

### VIRTUAL FUNCTIONS (_init ...) ###
func _input(event):
	if event is InputEventKey and event.pressed:
#		LOG.pr(LOG.LOG_TYPE.INTERNAL, "(%s) pressed" % [event.scancode])
		if event.scancode == KEY_QUOTELEFT: # Toggle DebugWindow
			debugWindow.visible = !debugWindow.visible

		if event.scancode == KEY_SPACE: # Wave start shortcut
			_on_wave_start_button_pressed()

		if event.scancode == KEY_P: # Pause with P
			LOG.pr(LOG.LOG_TYPE.INTERNAL, "PAUSED")
			battle.paused = not battle.paused
			UTILS.pause_node(battle, not battle.paused)

		if event.scancode == KEY_A: # Toggle Circles with A
			CONFIG.SHOW_RANGE_CIRCLES = not CONFIG.SHOW_RANGE_CIRCLES


func _ready():
	assert(player_base)
	# Init Player Base
	player_base.init()
	SIGNAL.bind(
		player_base, "player_main_base_destroyed",
		self, "_on_player_main_base_destroyed"
	)

	SIGNAL.bind(
		player_base, "hp_updated",
		baseHealthBar, "set_hp_value"
	)

	SIGNAL.bind(
		startWaveButton, "pressed",
		self, "_on_wave_start_button_pressed"
	)

	SIGNAL.bind_bulk(
		battle, self,
		[
			["unit_selected", "_on_unit_selected"],
			["unit_spawned", "_on_unit_spawned"],
			["wave_completed", "_on_wave_completed"],
		]
	)

	SIGNAL.bind(
		battle, "base_damaged",
		player_base, "take_damage"
	)

	SIGNAL.bind(
		battle, "material_collected",
		materialList, "_on_material_collected"
	)

	SIGNAL.bind(
		self, "material_used",
		materialList, "_on_material_used"
	)

	# TEMP
	for unit_data in unit_data_pool.get_items():
		assert(unit_data is UnitData)

		var new_unit_view = P_UnitView.instance()
		unitList.add_child(new_unit_view)
		new_unit_view.set_data(unit_data)
		SIGNAL.bind(
			new_unit_view, "pressed",
			self, "_on_unit_view_pressed",
			[unit_data]
		)

### PUBLIC FUNCTIONS ###
### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
func _on_unit_view_pressed(unit_data : UnitData) -> void:
	LOG.pr(LOG.LOG_TYPE.INPUT, "UNIT_VIEW PRESSED WITH [%s]" % [unit_data])
	if materialList.get_storage().covers_cost(unit_data.cost):
		battle.set_dragged_item(unit_data)


func _on_unit_spawned(unit_data : UnitData):
	# Spend the material cost of the unit
	var unit_cost_storage = unit_data.cost.get_materials()
	for mat in unit_cost_storage.keys():
		var count = unit_cost_storage.get(mat)
		emit_signal("material_used", mat, count)


func _on_unit_selected(unit) -> void:
	debugWindow.display_unit(unit)


func _on_wave_start_button_pressed() -> void:
	battle.start_next_wave()
	startWaveButton.hide()


func _on_wave_completed() -> void:
	startWaveButton.show()


func _on_player_main_base_destroyed() -> void:
	LOG.pr(LOG.LOG_TYPE.GAMEPLAY, "PLAYER LOST")
