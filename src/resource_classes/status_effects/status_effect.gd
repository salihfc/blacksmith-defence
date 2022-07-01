tool
extends Resource
class_name StatusEffect
"""
	Note: Expiration of StatusEffects handled by container
"""
### SIGNAL ###
signal expired()

### ENUM ###
# Probably Unnecessary after creating all the absractions
enum TYPE {
	NONE,

	BLEED,  # Take damage equal to stack count, duration is refreshed on application, remove all on expire
	IGNITE, # Take 30% of the damage every 0.5 for 4 seconds / max 3 stacks by default
	FREEZE, #
	CHILL,
	SHOCK,
	POISON, # Take damage proportional to log(stack_count), but every tick decrease x amount of stacks

	COUNT
}

### CONST ###
### EXPORT ###
export(TYPE) var type setget set_type, get_type
export(Texture) var icon setget set_icon, get_icon

# This function resources should inherit StatusEffectFunctionBase
export(Resource) var on_tick_function = null
export(Resource) var on_applied_function = null
export(Resource) var on_expired_function = null

### PUBLIC VAR ###
# Caution: originator holds weakref of originator unit
var originator setget set_originator, get_originator
var duration setget set_duration, get_duration
var value setget set_value, get_value

### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _to_string() -> String:
	var string = "StatusEffect"
	string += UTILS.wrap_str(
		UTILS.get_enum_string_from_id(TYPE, type) + ", " +
		"d:" + UTILS.wrap_str(str(duration)) + ", " +
		"v:" + UTILS.wrap_str(str(value))
	)
	return string

### PUBLIC FUNCTIONS ###
func tick(container, unit) -> void:
	if on_tick_function and unit:
		on_tick_function.execute(self, container, unit)


func apply(container, unit):
	if on_applied_function and unit:
		on_applied_function.execute(self, container, unit)


func expire(container, unit):
	if on_expired_function and unit:
		on_expired_function.execute(self, container, unit)

	emit_signal("expired")


func clone_from_prototype(prototype):
	return set_type(prototype.get_type())\
			.set_duration(prototype.get_duration())\
			.set_value(prototype.get_value())\
			.set_icon(prototype.get_icon())\
			.set_applied_function(prototype.get_applied_function())\
			.set_tick_function(prototype.get_tick_function())\
			.set_expired_function(prototype.get_expired_function())


func report():
	LOG.pr(LOG.LOG_TYPE.INTERNAL, "\n-------------------\n%s\n-------------------\n" % [self])
	return self


func get_tick_damage(container, unit):
	return on_tick_function.get_damage(self, container, unit)


func set_type(new_type):
	type = new_type
	return self


func get_type():
	return type


func set_icon(new_icon):
	icon = new_icon
	return self


func get_icon():
	return icon


func set_originator(origin):
	originator = weakref(origin)
	return self


func get_originator():
	if originator:
		return originator.get_ref()


func set_duration(new_duration):
	duration = new_duration
	return self


func get_duration():
	return duration


func set_value(new_value):
	value = new_value
	return self


func get_value():
	return value


func set_tick_function(new_tick_function):
	on_tick_function = new_tick_function
	return self


func get_tick_function():
	return on_tick_function


func set_applied_function(new_applied_function):
	on_applied_function = new_applied_function
	return self


func get_applied_function():
	return on_applied_function


func set_expired_function(new_expired_function):
	on_expired_function = new_expired_function
	return self


func get_expired_function():
	return on_expired_function
### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
