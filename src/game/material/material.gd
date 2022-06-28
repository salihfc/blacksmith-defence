extends Sprite
"""
"""
### SIGNAL ###
signal collected()

### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
var _mat : MaterialData
var _ct : int
var _collected = false

### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func set_data(mat : MaterialData, ct : int) -> void:
	_mat = mat
	_ct = ct
	texture = mat.sprite


func get_mat():
	return _mat


func get_count():
	return _ct


func play_drop_animation() -> void:
	TWEEN.interpolate_property_to_and_back(
		self, "scale",
		scale, Vector2.ZERO,
		0.3, 0.1
	)

	TWEEN.interpolate_method_to_and_back(
		self, "_set_shader_param_glow_anim_t",
		0.0, 1.0,
		0.1, 0.1
	)


func play_collect_animation() -> void:
	var anim_duration = 0.3

	TWEEN.interpolate_property(
		self, "scale",
		scale, Vector2.ZERO,
		anim_duration
	)

	yield(get_tree().create_timer(anim_duration), "timeout")
	queue_free()

### PRIVATE FUNCTIONS ###
func _set_shader_param_glow_anim_t(t : float) -> void:
	material.set_shader_param("in_anim_t", t)

### SIGNAL RESPONSES ###
func _on_MousePickingArea_area_entered(_area):
	if not _collected:
		_collected = true
		play_collect_animation()
		emit_signal("collected")
