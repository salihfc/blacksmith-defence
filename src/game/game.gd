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
const prefab_player_unit = preload("res://src/game/unit/sub_units/player_unit.tscn")
# PRELOADED TRES
### EXPORT ###
export(NodePath) var NodepathBattle
export(NodePath) var NodepathMaterialList
export(NodePath) var NodepathUnitList
export(NodePath) var NodepathDebugWindow

export(Resource) var unit_data_pool = null
### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###
onready var battle = get_node(NodepathBattle)
onready var materialList = get_node(NodepathMaterialList)
onready var unitList = get_node(NodepathUnitList)
onready var debugWindow = get_node(NodepathDebugWindow) as DebugWindow

### VIRTUAL FUNCTIONS (_init ...) ###
func _input(event):
	
	if event is InputEventKey and event.pressed:
#		LOG.pr(3, "(%s) pressed" % [event.scancode])
		if event.scancode == 96: # <`> TILDE
#			LOG.pr(3, "TILDE PRESSED")
			debugWindow.visible = !debugWindow.visible


func _ready():
	
	UTILS.bind(
		battle, "unit_selected",
		self, "_on_unit_selected"
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
	LOG.pr(1, "UNIT_VIEW PRESSED WITH [%s]" % [unit_data])
	
	if materialList.get_storage().covers_cost(unit_data.cost):
		var new_unit = prefab_player_unit.instance()
		battle.spawn_unit(new_unit)
		new_unit.init_with_data(unit_data)
		
		var unit_cost_storage = unit_data.cost.get_materials()
		for mat in unit_cost_storage.keys():
			var count = unit_cost_storage.get(mat)
			emit_signal("material_used", mat, count)


func _on_unit_selected(unit) -> void:
	debugWindow.display_unit(unit)
