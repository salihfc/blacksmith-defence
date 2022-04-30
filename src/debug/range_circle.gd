extends Node2D

"""

"""

### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(float) var radius = 1.0
export(Color) var color = Color.webmaroon
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _process(_delta):
	update()


func _draw():
	draw_arc(position, radius, 0.0, 2*PI, 36, color, 2.0, true)

### PUBLIC FUNCTIONS ###
### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
