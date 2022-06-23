extends Node2D

"""

"""

### SIGNAL ###
### ENUM ###
### CONST ###
const DEFAULT_FONT_COLOR = Color.whitesmoke
const CRIT_COLOR = Color.orange
const STARTING_OFFSET = Vector2.UP * 40.0
### EXPORT ###
export(Font) var CRIT_FONT
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
onready var label = $Label as Label
onready var tween = $Tween as Tween

### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	_set_color()
	set_as_toplevel(true)
	tween.connect("tween_all_completed", self, "_on_movement_done")

### PUBLIC FUNCTIONS ###
func init(start_pos : Vector2, text : String, movement = _get_random_movement()):

	start_pos += STARTING_OFFSET

	global_position = start_pos
	label.text = str(int(text))

	var duration = _get_random_duration()

	tween.interpolate_property(
			self, "global_position",
			start_pos, start_pos + movement,
			duration,
			Tween.TRANS_SINE, Tween.EASE_IN_OUT)

	tween.interpolate_property(
			self, "scale",
			scale, Vector2.ZERO,
			duration,
			Tween.TRANS_SINE, Tween.EASE_IN_OUT)

	tween.start()
	return self


func set_text_color(color = DEFAULT_FONT_COLOR):
	_set_color(color)


func set_crit(is_crit : bool = false):
	if is_crit:
		_set_color(CRIT_COLOR)
		label.set("custom_fonts/font", CRIT_FONT)
	else:
		_set_color()


### PRIVATE FUNCTIONS ###
func _get_random_movement():
	return UTILS.angle_to_vec2(rand_range(PI/3.0, 2.0*PI/3.0)) * 30.0 * Vector2(1.0, -1.0)


func _get_random_duration():
	return rand_range(0.5, 1.0)


func _set_color(color : Color = DEFAULT_FONT_COLOR) -> void:
	label.set("custom_colors/font_color", color)


### SIGNAL RESPONSES ###

func _on_movement_done() -> void:
	queue_free()
