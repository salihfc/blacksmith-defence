extends Resource
class_name StatusEffect
"""
"""
### SIGNAL ###
signal expired()

### ENUM ###
# Probably Unnecessary after creating all the absractions
enum TYPE {
	NONE,

	BLEED,
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
# This function resources should inherit StatusEffectFunctionBase
export(Resource) var on_tick_function = null
export(Resource) var on_applied_function = null
export(Resource) var on_expired_function = null

### PUBLIC VAR ###
var duration setget set_duration, get_duration
var value setget set_value, get_value

### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
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
			.set_applied_function(prototype.get_applied_function())\
			.set_tick_function(prototype.get_tick_function())\
			.set_expired_function(prototype.get_expired_function())


func set_type(new_type):
	type = new_type
	return self


func get_type():
	return type


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
