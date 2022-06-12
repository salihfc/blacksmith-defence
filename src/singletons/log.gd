tool
extends Node

# config
var LOG_INTERNAL	= true
var LOG_GAMEPLAY	= false
var LOG_SIGNAL	= false
var LOG_AI		= false
var LOG_VFX		= false
var LOG_SFX		= false
var LOG_INPUT	= false
var LOG_PHYSICS	= false

func _get(property: String):
	if property.begins_with("flags/"):
		property = property.trim_prefix("flags/")

	if property == 'LOG_INTERNAL':
		return LOG_INTERNAL

	elif property == 'LOG_GAMEPLAY':
		return LOG_GAMEPLAY

	elif property == 'LOG_SIGNAL':
		return LOG_SIGNAL

	elif property == 'LOG_AI':
		return LOG_AI

	elif property == 'LOG_VFX':
		return LOG_VFX

	elif property == 'LOG_SFX':
		return LOG_SFX

	elif property == 'LOG_INPUT':
		return LOG_INPUT

	elif property == 'LOG_PHYSICS':
		return LOG_PHYSICS

	return null

func _set(property: String, value) -> bool:
	if property.begins_with("flags/"):
		property = property.trim_prefix("flags/")

	if property == 'LOG_INTERNAL':
		LOG_INTERNAL = value

	elif property == 'LOG_GAMEPLAY':
		LOG_GAMEPLAY = value

	elif property == 'LOG_SIGNAL':
		LOG_SIGNAL = value

	elif property == 'LOG_AI':
		LOG_AI = value

	elif property == 'LOG_VFX':
		LOG_VFX = value

	elif property == 'LOG_SFX':
		LOG_SFX = value

	elif property == 'LOG_INPUT':
		LOG_INPUT = value

	elif property == 'LOG_PHYSICS':
		LOG_PHYSICS = value

	return true


func _get_property_list() -> Array:
	var props = []
	props.append_array(
		[
			{
				'name' : 'flags/LOG_INTERNAL',
				'type' : TYPE_BOOL,
			},
			{
				'name' : 'flags/LOG_GAMEPLAY',
				'type' : TYPE_BOOL,
			},
			{
				'name' : 'flags/LOG_SIGNAL',
				'type' : TYPE_BOOL,
			},
			{
				'name' : 'flags/LOG_AI',
				'type' : TYPE_BOOL,
			},
			{
				'name' : 'flags/LOG_VFX',
				'type' : TYPE_BOOL,
			},
			{
				'name' : 'flags/LOG_SFX',
				'type' : TYPE_BOOL,
			},
			{
				'name' : 'flags/LOG_INPUT',
				'type' : TYPE_BOOL,
			},
			{
				'name' : 'flags/LOG_PHYSICS',
				'type' : TYPE_BOOL,
			},
		]
	)
	return props


# masks
enum LOG_TYPE {
	SIGNAL		= 1 << 0,
	AI			= 1 << 1,
	GAMEPLAY	= 1 << 2,
	VFX			= 1 << 3,
	SFX			= 1 << 4,
	INPUT		= 1 << 5,
	PHYSICS		= 1 << 6,
	INTERNAL	= 1 << 7,


	COUNT		= 1 << 8,
}

func get_log_type_name(log_type, default = null):
	var _name = UTILS.get_enum_string_from_id(LOG_TYPE, _log_idx[log_type])
	if _name:
		return _name
	return default

# runtime mask
var runtime_mask = 0
var _log_idx = {}

func _ready() -> void:

	for i in UTILS.log2i(LOG_TYPE.COUNT):
		_log_idx[1 << i] = i

	# Calculate runtime mask
	runtime_mask += int(LOG_SIGNAL) * LOG_TYPE.SIGNAL
	runtime_mask += int(LOG_AI) * LOG_TYPE.AI
	runtime_mask += int(LOG_GAMEPLAY) * LOG_TYPE.GAMEPLAY
	runtime_mask += int(LOG_VFX) * LOG_TYPE.VFX
	runtime_mask += int(LOG_SFX) * LOG_TYPE.SFX
	runtime_mask += int(LOG_INPUT) * LOG_TYPE.INPUT
	runtime_mask += int(LOG_PHYSICS) * LOG_TYPE.PHYSICS
	runtime_mask += int(LOG_INTERNAL) * LOG_TYPE.INTERNAL

	pr(LOG_TYPE.INTERNAL, "READY [log_mask:%s]" % [runtime_mask], "LOG")

# LOG LEVELS
# 0: All
# 1: TRACE
# 2: AI
# 3: DEBUG
# 4: WARN
# 5: ERROR / FATAL

func pr(log_mask: int, log_msg, caller:String = "") -> void:
	if log_mask & runtime_mask == 0: return

	var msg = str(log_msg) + " -- \t\t\t\t[%s]"%caller
	msg = get_log_type_name(log_mask, "UNK") + " -- " + msg
	print(msg)


func err(err_msg, caller:String = "") -> void:
	var msg = str(err_msg) + ("\t\t\t\t[%s]"%caller)
	msg = "ERROR" + " -- " + msg
	push_error(msg)


