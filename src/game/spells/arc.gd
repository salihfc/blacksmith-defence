extends Node2D
"""
"""
### SIGNAL ###
signal fizzled()
### ENUM ###
### CONST ###
### EXPORT ###
export(float) var fizzle_duration = 0.2
export(float) var out_duration = 0.1

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
onready var line = $Line2D as Line2D
onready var timer = $Timer as Timer
### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	timer.autostart = false
	timer.one_shot = true

	SIGNAL.bind(
		timer, "timeout",
		self, "_on_timeout"
	)

### PUBLIC FUNCTIONS ###
func set_pos_and_target(pos : Vector2, target) -> void:
	set_as_toplevel(true)
	global_position = pos
	line.clear_points()
	line.add_point(Vector2.ZERO)
	line.add_point(target.global_position - pos)


func animate_fizzle() -> void:
	var total = fizzle_duration + out_duration

	TWEEN.interpolate_method(
		self, "_set_anim_t",
		0.0, total,
		total
	)

	timer.start(total)

### PRIVATE FUNCTIONS ###
# 			fffffooooooo
# begin:    00000++++++1
# end:    	0+++11111111
func _set_anim_t(anim_t : float) -> void:
	var begin = clamp((anim_t - fizzle_duration) * (1.0 / out_duration), 0.0, 1.0)
	var end = clamp(anim_t * (1.0 / fizzle_duration), 0.0, 1.0)

	line.material.set_shader_param("begin", begin)
	line.material.set_shader_param("end", end)

### SIGNAL RESPONSES ###
func _on_timeout() -> void:
	emit_signal("fizzled")
	queue_free()
