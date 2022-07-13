extends SpellBase
class_name Tornado
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(Resource) var damage = Damage.new(Damage.TYPE.EARTH, 20.0)
export(float) var speed = 400.0
export(float) var fade_out_duration = 0.5
export(float) var grow_time = 1.0
export(float) var travel_distance = 800.0
export(float) var base_radius = 100.0
export(float) var _radius = 100.0 setget _set_radius

### PUBLIC VAR ###
### PRIVATE VAR ###
var _castable = true

### ONREADY VAR ###
onready var damageArea = $Areas/DamageArea as ObjectArea
onready var backAnim = $Pivot/BackAnim as AnimatedSprite
onready var frontAnim = $Pivot/FrontAnim as AnimatedSprite

### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	hide()

### PUBLIC FUNCTIONS ###
func cast(
		_starting_point : Vector2 = get_owner().global_position,
		_possible_targets : Array = get_possible_targets()
	) -> void:

	if not _castable:
		return

	# Tornado cast in a straight line
	var dir = Vector2.RIGHT
	var end_pos = _starting_point + dir.normalized() * travel_distance

	var travel_time = travel_distance / speed
	var fade_time = fade_out_duration
	var total_time = travel_time + fade_time

	TWEEN.interpolate_method(
			self, "set_pos",
			_starting_point, end_pos,
			travel_time,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

	TWEEN.interpolate_property(
			$Pivot, "global_scale",
			Vector2.ONE / 2.0, $Pivot.global_scale,
			grow_time
	)

	# Fade-out start after travel time
#	TWEEN.interpolate_method(
#		self, "_set_shader_fade",
#		0.0, 1.0,
#		fade_out_duration - 0.01,
#		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT,
#		travel_time - 0.01
#	)

	# Cleanup happens after total time
	TIMER_ALLOC.alloc(
			self, "_on_travel_done",
			total_time + 0.02)

	_set_shader_fade(0.0)
	show()


func get_radius() -> float:
	return 100.0 # TODO: make dynamic


func get_cast_range() -> float:
	return 280.0


func set_pos(pos : Vector2):
#	set_as_toplevel(true)
	global_position = pos


func set_owner_unit(_owner):
	.set_owner_unit(_owner)
	var owner_spell_aoe = _owner.get_stat(StatContainer.STATS.SPELL_AOE)

	LOG.pr(LOG.LOG_TYPE.INTERNAL, "|||||||||||||owner_aoe|||||||||||| > [%s]" % [owner_spell_aoe])
	if owner_spell_aoe:
		_set_radius(get_radius() * owner_spell_aoe)


func get_total_damage():
	return CumulativeDamage.new([
		Damage.new().copy_from(damage)\
				.increased_by(get_owner().get_stat(StatContainer.STATS.BASE_DAMAGE))\
				.set_originator(get_owner()),
	])

### PRIVATE FUNCTIONS ###
func _set_radius(new_radius : float) -> void:
	_radius = new_radius
	global_scale *= Vector2.ONE * float(_radius / base_radius)


func _set_shader_fade(fade_frac : float) -> void:
	backAnim.material.set_shader_param("fade_out_fraction", fade_frac)
	frontAnim.material.set_shader_param("fade_out_fraction", fade_frac)


### SIGNAL RESPONSES ###
func _on_DamageArea_area_entered(area: Area2D) -> void:
	var ent = area.get_owner()
	_damage_targets([ent])


func _on_travel_done(_timer) -> void:
	hide()
	position = Vector2.ZERO
	_castable = true
