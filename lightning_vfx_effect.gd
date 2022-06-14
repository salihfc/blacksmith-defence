extends Node2D
class_name ClassName
"""
"""

### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(int) var point_count = 15

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
onready var _line = $Position2D/Line2D as Line2D
onready var _line2 = $Position2D/Line2D2 as Line2D
var side = 0

### VIRTUAL FUNCTIONS (_init ...) ###
func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_SPACE):
		generate(_line)
		generate(_line2)


#func _physics_process(_delta: float) -> void:
#	generate(_line)
#	generate(_line2)


func _ready() -> void:
	randomize()
	generate(_line)
	generate(_line2)


func generate(line):
	line.clear_points()

	side = randi() % 2
	line.add_point(Vector2.ZERO)

	for i in (point_count - 1):
		var dir = _random_direction(deg2rad(0), deg2rad(45))
		var r = UTILS.gauss_random(30, 100)
		var offset = dir * r
		line.add_point(line.get_point_position(line.get_point_count() - 1) + offset)

		side = 1 - side

### PUBLIC FUNCTIONS ###
### PRIVATE FUNCTIONS ###
func _random_direction(min_angle, max_angle):
	var t = 0
	var down_vec_angle = PI + PI/2.0

	if side == 0:
		t = UTILS.gauss_random(
			down_vec_angle - max_angle,
			down_vec_angle - min_angle
		)
	else:
		t = UTILS.gauss_random(
			down_vec_angle + min_angle,
			down_vec_angle + max_angle
		)

	return Vector2(cos(t), sin(t))

### SIGNAL RESPONSES ###
