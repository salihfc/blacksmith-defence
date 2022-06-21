tool
extends Node2D
class_name RangeCircle
"""

"""

### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(float) var radius = 1.0
export(float) var thickness = 1.0
#export(Color) var color = Color(0.0, 0.0, 0.0, 0.2)
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	add_to_group("range_circles")
	visible = CONFIG.SHOW_RANGE_CIRCLES


#func _process(_delta):
#	update()



func _draw():
	draw_arc(position, radius, 0.0, 2*PI, 36, Color.white, thickness, true)

### PUBLIC FUNCTIONS ###
### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
