extends Control

"""

"""

### SIGNAL ###
signal material_used(mat, count)
### ENUM ###
### CONST ###
# UI/VIEW PREFABS
const prefab_unit_view = preload("res://src/game/unit_list_unit_view.tscn")

# GAME OBJECT PREFABS
#const prefab_unit = preload("res://src/game/unit/unit.tscn")
# PRELOADED TRES
### EXPORT ###
export(NodePath) var NodepathBattle
export(NodePath) var NodepathMaterialList
export(NodePath) var NodepathUnitList
export(NodePath) var NodepathDebugWindow
export(NodePath) var NodepathStartButton
export(NodePath) var NodepathBaseHealthBar

export(Resource) var unit_data_pool = null
export(Resource) var player_base = null
### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###
onready var battle = get_node(NodepathBattle)
onready var materialList = get_node(NodepathMaterialList)
onready var unitList = get_node(NodepathUnitList)
onready var debugWindow = get_node(NodepathDebugWindow) as DebugWindow
onready var startWaveButton = get_node(NodepathStartButton)
onready var baseHealthBar = get_node(NodepathBaseHealthBar)

### VIRTUAL FUNCTIONS (_init ...) ###
func _input(event):

	if event is InputEventKey and event.pressed:
#		LOG.pr(LOG.LOG_TYPE.INTERNAL, "(%s) pressed" % [event.scancode])
		if event.scancode == 96: # <`> TILDE
#			LOG.pr(LOG.LOG_TYPE.INPUT, "TILDE PRESSED")
			debugWindow.visible = !debugWindow.visible

		if event.scancode == KEY_SPACE: # < > SPACE
#			LOG.pr(LOG.LOG_TYPE.INPUT, "SPACE PRESSED")
			_on_wave_start_button_pressed()

		if event.scancode == KEY_P: # < > P
			LOG.pr(LOG.LOG_TYPE.INTERNAL, "PAUSE PRESSED\n")
			battle.paused = not battle.paused
			UTILS.pause_node(battle, not battle.paused)





func _ready():

	if player_base:
		player_base.init()
		UTILS.bind(
			player_base, "player_main_base_destroyed",
			self, "_on_player_main_base_destroyed"
		)

		UTILS.bind(
			player_base, "hp_updated",
			baseHealthBar, "set_hp_value"
		)

	UTILS.bind(
		startWaveButton, "pressed",
		self, "_on_wave_start_button_pressed"
	)

	UTILS.bind_bulk(
		battle, self,
		[
			["unit_selected", "_on_unit_selected"],
			["unit_spawned", "_on_unit_spawned"],
			["wave_completed", "_on_wave_completed"],
		]
	)

	UTILS.bind(
		battle, "base_damaged",
		player_base, "take_damage"
	)

	UTILS.bind(
		battle, "material_collected",
		materialList, "_on_material_collected"
	)


	UTILS.bind(
		self, "material_used",
		materialList, "_on_material_used"
	)

	# TEMP
	for unit_data in unit_data_pool.get_items():
		assert(unit_data is UnitData)

		var new_unit_view = prefab_unit_view.instance()
		unitList.add_child(new_unit_view)
		new_unit_view.set_data(unit_data)
		UTILS.bind(
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
