extends Control
class_name ModListDisplay
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(PackedScene) var P_ModDisplay

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
onready var container = $HBoxContainer as HBoxContainer

### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func clear():
	UTILS.clear_children(container)
	return self


func add_display_from_icon(icon):
	var display = P_ModDisplay.instance()
	container.add_child(display)
	display.set_icon(icon)
	return self

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###

