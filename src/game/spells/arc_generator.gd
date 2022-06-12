extends SpellBase
"""
"""
### SIGNAL ###
signal target_hit(target, damage)

### ENUM ###
### CONST ###
const P_Arc = preload("res://src/game/spells/arc.tscn")

### EXPORT ###
export(float) var jump_delay = 0.01
export(float) var jump_range = 125.0
export(Resource) var damage = Damage.new(Damage.TYPE.LIGHTNING, 10.0)

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func get_target_count():
	return 3 # This will be dynamic with enchancements


# Sends a wave of arc through targets
func cast(
		starting_point : Vector2 = self.global_position,
		possible_targets : Array = get_possible_targets(),
		max_targets : int = get_target_count()
	) -> void:

	global_position = starting_point
	var end_points_targets = [self]
	var target_ct = 0

	while target_ct < max_targets:
		# Closest target to the current end_points_targets
		var closest = null
		var end_point_to_fizzle = null
		var min_dist = INF

		for point in end_points_targets:
			for target in possible_targets:
				var dist = target.global_position.distance_to(point.global_position)
				if closest == null or dist < min_dist:
					min_dist = dist
					closest = target
					end_point_to_fizzle = point

		if closest and min_dist <= jump_range:
			end_points_targets.push_back(closest)
			possible_targets.erase(closest)

			var new_arc = P_Arc.instance()
			add_child(new_arc)
			new_arc.set_pos_and_target(end_point_to_fizzle.global_position, closest)
			new_arc.animate_fizzle()

			SIGNAL.bind(
				new_arc, "fizzled",
				closest, "take_damage",
				[damage]
			)

			target_ct += 1
		else:
			break

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
