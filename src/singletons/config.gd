extends Node

# ConstExprs
const ENEMY_GROUP = "enemy"

# Debug Settings
const SPAWN_ENEMIES = false
const SHOW_AI_STATE = false
const SHOW_HP_BARS = false
const SHOW_FLOATING_DAMAGE_NUMBERS = true

# Dynamic Debug
var SHOW_RANGE_CIRCLES : bool = true setget _set_show_range_circles

# Vars
onready var context = Context.new()


func _ready() -> void:
	LOG.pr(LOG.LOG_TYPE.INTERNAL, "READY", "CONFIG")
	OS.center_window()
	Engine.target_fps = 60


func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE) and OS.is_debug_build():
		get_tree().quit()


func _set_show_range_circles(show : bool) -> void:
	SHOW_RANGE_CIRCLES = show

	if SHOW_RANGE_CIRCLES:
		get_tree().call_group("range_circles", "show")
	else:
		get_tree().call_group("range_circles", "hide")
