extends Node

# ConstExprs
const DEBUG_GROUP = "debug"
const ENEMY_GROUP = "enemy"

export(Resource) var config

# Debug Settings
var SPAWN_ENEMIES

var SHOW_VFX
var SHOW_AI_STATE
var SHOW_HP_BARS
var SHOW_FLOATING_DAMAGE_NUMBERS

# Dynamic Debug
var SHOW_RANGE_CIRCLES : bool setget _set_show_range_circles
var DEBUG_ON setget _set_DEBUG_ON

# Vars
onready var context = Context.new()

func _unhandled_key_input(event: InputEventKey) -> void:
	if event.scancode == KEY_E and event.pressed:
		LOG.pr(LOG.LOG_TYPE.INPUT, "Toggle DEBUG_ON [%s]" % [not DEBUG_ON])
		_set_DEBUG_ON(not DEBUG_ON)


func _ready() -> void:
	assert(config)
	config = config as DevConfig

	SPAWN_ENEMIES = config.SPAWN_ENEMIES
	SHOW_VFX = config.SHOW_VFX
	SHOW_HP_BARS = config.SHOW_HP_BARS
	SHOW_FLOATING_DAMAGE_NUMBERS = config.SHOW_FLOATING_DAMAGE_NUMBERS
	SHOW_AI_STATE = config.SHOW_AI_STATE

	_set_show_range_circles(config.SHOW_RANGE_CIRCLES)
	_set_DEBUG_ON(config.DEBUG_ON)


	LOG.pr(LOG.LOG_TYPE.INTERNAL, "READY", "CONFIG")
	OS.center_window()
#	Engine.target_fps = 60

	var _err = get_tree().connect("node_added", self, "_on_node_added")


func _set_show_range_circles(show : bool) -> void:
	SHOW_RANGE_CIRCLES = show

	if SHOW_RANGE_CIRCLES:
		get_tree().call_group("range_circles", "show")
	else:
		get_tree().call_group("range_circles", "hide")


func _set_DEBUG_ON(on : bool) -> void:
	DEBUG_ON = on
	if DEBUG_ON:
		get_tree().call_group(DEBUG_GROUP, "show")
	else:
		get_tree().call_group(DEBUG_GROUP, "hide")


func _on_node_added(node : Node):
	if node.is_in_group(DEBUG_GROUP):
		assert(node.get("visible") != null)
		node.visible = DEBUG_ON
