extends Control

"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###
# UI/VIEW PREFABS
const prefab_unit_view = preload("res://src/game/unit_list_unit_view.tscn")

# GAME OBJECT PREFABS
#const prefab_unit = preload("res://src/game/unit/unit.tscn")
const prefab_player_unit = preload("res://src/game/unit/sub_units/player_unit.tscn")


# PRELOADED TRES
const unit_data_arr = [
	preload("res://src/game/unit/default_unit_data.tres"),
]
### EXPORT ###
export(NodePath) var NodepathBattle
export(NodePath) var NodepathMaterialList
export(NodePath) var NodepathUnitList
export(NodePath) var NodepathDebugWindow
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
	
	# TEMP
	for unit_data in unit_data_arr:
		assert(unit_data is UnitData)

		var new_unit_view = prefab_unit_view.instance()
		unitList.add_child(new_unit_view)

		new_unit_view.texture_normal = unit_data.texture
		
		UTILS.bind(
			new_unit_view, "pressed",
			self, "_on_unit_view_pressed",
			[unit_data]
		)

### PUBLIC FUNCTIONS ###


### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###
func _on_unit_view_pressed(_unit_data : UnitData) -> void:
	LOG.pr(1, "UNIT_VIEW PRESSED WITH [%s]" % [_unit_data])
	
	var new_unit = prefab_player_unit.instance()
	battle.spawn_unit(new_unit)
	new_unit.init_with_data(_unit_data)


func _on_unit_selected(unit) -> void:
	debugWindow.display_unit(unit)
