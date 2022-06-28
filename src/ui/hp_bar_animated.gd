extends Control
class_name AnimatedHpBar
"""
	Note: Use 'set_value_fraction'
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(bool) var hide_at_max_value = false
export(float) var hit_damage_sync_delay = 1.0
export(float) var animation_duration = 0.8

export(NodePath) var NP_Delayed
export(NodePath) var NP_Progress
export(NodePath) var NP_Timer

### PUBLIC VAR ###
### PRIVATE VAR ###
var _saved_value

### ONREADY VAR ###
# Note: TextureProgress uses interval [0, 100] by default need to multiply the given fraction
# before using
onready var delayed = get_node(NP_Delayed) as TextureProgress
onready var progress = get_node(NP_Progress) as TextureProgress
onready var sync_timer = get_node(NP_Timer) as Timer

### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	SIGNAL.bind(
		sync_timer, "timeout",
		self, "_on_sync_timeout"
	)
	progress.value = 100.0
	delayed.value = 100.0
	_saved_value = progress.value

### PUBLIC FUNCTIONS ###
func set_value_fraction(fraction : float) -> void:
	if hide_at_max_value:
		visible = fraction < 1.0

	# Update delayed to be progress before updating progress
	_sync_delayed_to_progress()
	_saved_value = _get_perc(fraction)
	_animate_progress(progress, _saved_value)
	sync_timer.start(hit_damage_sync_delay)

### PRIVATE FUNCTIONS ###
func _get_perc(fraction):
	return int(fraction * 100.0)

func _animate_progress(progress_node, new_value, duration = animation_duration) -> void:
	TWEEN.interpolate_property(
			progress_node, "value",
			progress_node.value, new_value,
			duration)


func _sync_delayed_to_progress() -> void:
	_animate_progress(delayed, _saved_value, animation_duration / 2.0)

### SIGNAL RESPONSES ###
func _on_sync_timeout() -> void:
	_sync_delayed_to_progress()


func _on_value_updated(value, max_value) -> void:
	assert(max_value != 0)
	set_value_fraction(value / max_value)
