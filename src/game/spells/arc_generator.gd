extends SpellBase
"""
"""
### SIGNAL ###


### ENUM ###
### CONST ###
const P_Arc = preload("res://src/game/spells/arc.tscn")

### EXPORT ###
export(float) var jump_delay = 0.01
export(float) var jump_range = 125.0
export(int) var base_chain = 1
export(Resource) var damage = Damage.new(Damage.TYPE.LIGHTNING, 10.0)

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func get_target_count():
	assert(owner_unit_weakref)
	var _owner = owner_unit_weakref.get_ref()
	if _owner:
		return base_chain + _owner.get_stat(StatContainer.STATS.CHAIN_COUNT)
	return 0


func get_total_damage():
	return CumulativeDamage.new([
		damage.increased_by(get_owner().get_stat(StatContainer.STATS.BASE_DAMAGE)),
	])


# Sends a wave of arc through targets
func cast(
		starting_point : Vector2 = self.global_position,
		possible_targets : Array = get_possible_targets(),
		max_targets : int = get_target_count()
	) -> void:
	assert(owner_unit_weakref)

	LOG.pr(LOG.LOG_TYPE.INTERNAL, "[%s] CASTING" % [get_owner()])

	global_position = starting_point
	var end_points_targets = [self]
	var target_ct = 0
	var total_damage = get_total_damage()

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
				[total_damage]
			)

			# FIXME: Carry this into Unit class
			SIGNAL.bind(
				new_arc, "fizzled",
				self, "_on_arc_hit_enemy",
				[closest, total_damage]
			)

			target_ct += 1
		else:
			break

	LOG.pr(LOG.LOG_TYPE.SFX, "ARC GENERATED: playing SFX")
	AUDIO.play(AUDIO.SFX.SPELL_ARC)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###

func _on_arc_hit_enemy(_target, _damage) -> void:
	emit_signal("enemy_hit", _target, _damage)
