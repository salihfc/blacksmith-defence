extends SpellBase
class_name Incinerate
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
# editor
export(bool) var autocast = false
#
export(Resource) var damage = Damage.new(Damage.TYPE.FIRE, 10.0)

### PUBLIC VAR ###
### PRIVATE VAR ###
var _casting = false
var direction_ct : int = 0

### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	direction_ct = 0
	for direction in get_children():
		SIGNAL.bind_bulk(
			direction, self,
				[
					["damage_frame_reached", "_on_direction_damage_frame_reached", [direction]],
					["done", "_on_direction_done", [direction]],
				]
		)

func get_total_damage():
	return CumulativeDamage.new([
		Damage.new().copy_from(damage)\
				.increased_by(get_owner().get_stat(StatContainer.STATS.BASE_DAMAGE))\
				.set_originator(get_owner()),
	])

### PUBLIC FUNCTIONS ###
func cast(
		_starting_point : Vector2 = self.global_position,
		_possible_targets : Array = get_possible_targets(),
		_max_targets : int = 0
	) -> void:
	assert(Engine.editor_hint or owner_unit_weakref)

	LOG.pr(LOG.LOG_TYPE.INTERNAL, "[%s] CASTING {%s}" % [get_owner(), _casting])

	if not _casting:
		var cast_dir = get_child(direction_ct)
		cast_dir.activate()
		_casting = true
		direction_ct = (direction_ct + 1) % (get_child_count())


### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
func _on_direction_damage_frame_reached(direction):
	var targets_in_area = UTILS.get_owners(direction.get_units_inside())
	_damage_targets(targets_in_area)


func _on_direction_done(_direction) -> void:
	_casting = false

	if autocast:
		cast()
