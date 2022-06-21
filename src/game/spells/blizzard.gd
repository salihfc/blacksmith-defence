extends SpellBase
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(Resource) var damage = Damage.new(Damage.TYPE.WATER, 20.0)
export(float) var speed_mod = 0.8
export(float) var base_range = 100.0
export(float) var _range = 100.0 setget _set_range

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
onready var animPlayer = $AnimationPlayer as AnimationPlayer
onready var damageArea = $Areas/DamageArea as ObjectArea

### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func cast(
		_starting_point : Vector2 = self.global_position,
		_possible_targets : Array = get_possible_targets()
	) -> void:
	# Find best place to cast blizzard
	# Try casting on top of every target: O(n*n)
	var max_target_count = 0
	var best_target = null

	for main_target in _possible_targets:
		var cast_position = main_target.global_position
		var ct = 0
		if cast_position.distance_to(_starting_point) > get_cast_range():
			continue

		for target in _possible_targets:
			if cast_position.distance_to(target.global_position) <= get_radius():
				ct += 1

		if ct > max_target_count:
			max_target_count = ct
			best_target = main_target

	if best_target:
		_cast_on(best_target.global_position)


func get_radius() -> float:
	return 100.0 # TODO: make dynamic


func get_cast_range() -> float:
	return 280.0


func set_pos(pos : Vector2):
	set_as_toplevel(true)
	global_position = pos


func get_total_damage():
	return CumulativeDamage.new([
		damage.increased_by(get_owner().get_stat(StatContainer.STATS.BASE_DAMAGE)),
	])


func animate():
	animPlayer.play("pulse")

### PRIVATE FUNCTIONS ###
func _set_range(new_range : float) -> void:
	_range = new_range
	global_scale *= Vector2.ONE * float(_range / base_range)


func _cast_on(cast_position : Vector2) -> void:
	set_as_toplevel(true)
	global_position = cast_position
	animate()


func _on_damage_frame() -> void:
	var targets_in_area = UTILS.get_owners(damageArea.get_areas_inside())
	for target in targets_in_area:
		if target.has_method("take_damage"):
			target.take_damage(get_total_damage())
		else:
			push_warning("target cannot take damage")


func _enable_hitbox(enabled := true):
	damageArea.disabled = not enabled

### SIGNAL RESPONSES ###
func _on_SlowArea_area_entered(_area: Area2D) -> void:
	pass
#	var object = area.get_owner()
#	if object and object.has_method("apply_move_speed_mod"):
#		object.apply_move_speed_mod(speed_mod)
