extends PanelContainer
class_name DebugWindow

"""

"""

### SIGNAL ###
### ENUM ###
### CONST ###
const PrefabRowData = preload("res://src/debug/row_data.tscn")
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
onready var listView = $VBoxContainer as VBoxContainer
### VIRTUAL FUNCTIONS (_init ...) ###


### PUBLIC FUNCTIONS ###
func display_unit(unit) -> void:
	UTILS.clear_children(listView)
	var info = unit.get_info()
	var row_data_view = PrefabRowData.instance()
	listView.add_child(row_data_view)
	row_data_view.fill_with(info)


### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
