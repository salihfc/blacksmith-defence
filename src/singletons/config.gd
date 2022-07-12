extends Node

# ConstExprs
const DEBUG_GROUP = "debug"
const ENEMY_GROUP = "enemy"

# Debug Settings
const SPAWN_ENEMIES = false

const SHOW_VFX = true
const SHOW_AI_STATE = false
const SHOW_HP_BARS = true
const SHOW_FLOATING_DAMAGE_NUMBERS = true

# Dynamic Debug
var SHOW_RANGE_CIRCLES : bool = false setget _set_show_range_circles

var DEBUG_ON = false setget _set_DEBUG_ON

# Vars
onready var context = Context.new()

func _unhandled_key_input(event: InputEventKey) -> void:
	if event.scancode == KEY_E and event.pressed:
		LOG.pr(LOG.LOG_TYPE.INPUT, "Toggle DEBUG_ON [%s]" % [not DEBUG_ON])
		_set_DEBUG_ON(not DEBUG_ON)


func _ready() -> void:
	LOG.pr(LOG.LOG_TYPE.INTERNAL, "READY", "CONFIG")
	OS.center_window()
	Engine.target_fps = 60

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
