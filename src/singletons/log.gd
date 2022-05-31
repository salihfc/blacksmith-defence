extends Node

# config
const LOG_INTERNAL	= true
const LOG_GAMEPLAY	= false

const LOG_SIGNAL	= false
const LOG_AI		= false
const LOG_VFX		= false
const LOG_SFX		= false
const LOG_INPUT		= false
const LOG_PHYSICS	= false

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
}

const LOG_TYPE_NAMES = {
	LOG_TYPE.AI : "AI",
	LOG_TYPE.GAMEPLAY : "GAMEPLAY",
	LOG_TYPE.SIGNAL : "SIGNAL",
	
	LOG_TYPE.VFX : "VFX",
	LOG_TYPE.SFX : "SFX",
	
	LOG_TYPE.INPUT : "INPUT",

	LOG_TYPE.PHYSICS : "PHYSICS",
	LOG_TYPE.INTERNAL : "INTERNAL",
}

# runtime mask
var runtime_mask = 0

func _ready() -> void:
	# Calculate runtime mask
	runtime_mask += int(LOG_SIGNAL) * LOG_TYPE.SIGNAL
	runtime_mask += int(LOG_AI) * LOG_TYPE.AI
	runtime_mask += int(LOG_GAMEPLAY) * LOG_TYPE.GAMEPLAY
	runtime_mask += int(LOG_VFX) * LOG_TYPE.VFX
	runtime_mask += int(LOG_SFX) * LOG_TYPE.SFX
	runtime_mask += int(LOG_INPUT) * LOG_TYPE.INPUT
	runtime_mask += int(LOG_PHYSICS) * LOG_TYPE.PHYSICS
	runtime_mask += int(LOG_INTERNAL) * LOG_TYPE.INTERNAL

	pr(3, "READY [log_mask:%s]" % [runtime_mask], "LOG")


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
	msg = LOG_TYPE_NAMES.get(log_mask, "UNK") + " -- " + msg
	print(msg)


func err(err_msg, caller:String = "") -> void:
	var msg = str(err_msg) + ("\t\t\t\t[%s]"%caller)
	msg = "ERROR" + " -- " + msg
	push_error(msg)


