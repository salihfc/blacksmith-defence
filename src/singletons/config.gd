extends Node

# ConstExprs
const ENEMY_GROUP = "enemy"


# Debug Settings
const SPAWN_ENEMIES = false
const SHOW_AI_STATE = false
const SHOW_HP_BARS = false
const SHOW_FLOATING_DAMAGE_NUMBERS = true

# Vars
onready var context = Context.new()


func _ready() -> void:
	LOG.pr(LOG.LOG_TYPE.INTERNAL, "READY", "CONFIG")
	OS.center_window()
	Engine.target_fps = 60


func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE) and OS.is_debug_build():
		get_tree().quit()
