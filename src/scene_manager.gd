extends CanvasLayer
class_name SceneManager
"""
"""

### SIGNAL ###
### ENUM ###
enum SCENE {
	MAIN_MENU,
	SETTINGS,
	HOWTO,
	CREDITS,

	GAME,
	GAME_3,
}

const SCENES = {
	SCENE.MAIN_MENU : preload("res://src/main_menu.tscn"),
	SCENE.SETTINGS : preload("res://src/settings_menu.tscn"),
	SCENE.HOWTO : preload("res://src/how_to.tscn"),
	SCENE.CREDITS : preload("res://src/credits.tscn"),
#	SCENE.GAME : preload("res://src/game/game.tscn"),
#	SCENE.GAME : preload("res://src/game/game_v2.tscn"),

	SCENE.GAME_3 : preload("res://src/game/game_v3.tscn"),
}

const PREV_SCENE = {
	SCENE.SETTINGS : SCENE.MAIN_MENU,
	SCENE.HOWTO : SCENE.MAIN_MENU,
	SCENE.CREDITS : SCENE.MAIN_MENU,
#	SCENE.GAME : SCENE.MAIN_MENU,
	SCENE.GAME_3 : SCENE.MAIN_MENU,
}


### CONST ###
const DEFAULT_FOREGROUND_COLOR = Color("0c0d1d")
const FULL_TRANSPARENT = Color(0.0, 0.0, 0.0, 0.0)
const FADE_MIN_DELAY = 0.3
const RECOVERY_MIN_DELAY = 0.5

export(SCENE) var STARTING_SCENE = SCENE.MAIN_MENU
### EXPORT ###
export(Texture) var mouse_normal_cursor
export(Texture) var mouse_pressed_cursor

### PUBLIC VAR ###
### PRIVATE VAR ###
var _current_scene = STARTING_SCENE
var _loading = false

### ONREADY VAR ###
onready var foreground = $FadeRectLayer/Control/Foreground as ColorRect
onready var sceneSlot = $CurrentSceneSlot as Control
onready var dumpSlot = $DumpSlot as Control

### VIRTUAL FUNCTIONS (_init ...) ###
func _input(event):
	if GROUP.get_global(GROUP.SCENE_MANAGER).is_loading():
		return

	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if CONFIG.CUSTOM_MOUSE:
				if event.pressed:
					Input.set_custom_mouse_cursor(mouse_pressed_cursor)
				else:
					Input.set_custom_mouse_cursor(mouse_normal_cursor)


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.scancode == KEY_ESCAPE and event.pressed:
		if _current_scene in PREV_SCENE:
			change_scene(PREV_SCENE[_current_scene])
		else:
			LOG.pr(LOG.LOG_TYPE.INTERNAL, "Exiting..")
			get_tree().quit()


func _ready() -> void:
	add_to_group(str(GROUP.SCENE_MANAGER))
	randomize()
	LOG.pr(LOG.LOG_TYPE.INTERNAL, "READY", "SCENE_MANAGER")
	set_foreground_color(DEFAULT_FOREGROUND_COLOR)

	if CONFIG.CUSTOM_MOUSE:
		Input.set_custom_mouse_cursor(mouse_normal_cursor)

	change_scene(STARTING_SCENE)


### PUBLIC FUNCTIONS ###
func is_loading():
	return _loading


func scene_loaded():
	_loading = false
	fade_in()


func set_foreground_color(new_color : Color) -> void:
	foreground.color = new_color


func change_scene(scene_id) -> void:
	_loading = true
	fade_out(scene_id)


func fade_out(scene_id):
	fade(1.0, FADE_MIN_DELAY)
	TWEEN.interpolate_callback(self, "add_scene", FADE_MIN_DELAY, [scene_id])


func add_scene(scene_id):
	if sceneSlot.get_child_count():
		UTILS.transfer_children(sceneSlot, dumpSlot)
		UTILS.call_deferred("clear_children", dumpSlot)

	_current_scene = scene_id
	var scene = SCENES[(scene_id)].instance()
	sceneSlot.add_child(scene)


func fade_in():
	bind_ui_buttons()
	fade(0.0, RECOVERY_MIN_DELAY)


func fade(alpha, duration := 0.5) -> void:
	var to = foreground.color
	to.a = alpha

	TWEEN.interpolate_property(
			foreground, "color",
			foreground.color, to,
			duration,
			Tween.TRANS_QUAD, Tween.EASE_IN_OUT
	)


func bind_ui_buttons():
	var ui_buttons = get_tree().get_nodes_in_group("ui_button")
	LOG.pr(LOG.LOG_TYPE.SFX, "UI_BUTTONS: %s" % [ui_buttons])

	for button in ui_buttons:
		SIGNAL.bind_bulk(button, AUDIO,
			[
				["mouse_entered", "play_ui_sfx", [AUDIO.UI_SFX.HOVER_BLIP]],
				["pressed", "play_ui_sfx", [AUDIO.UI_SFX.PRESS_BLIP]],
			],

			true # check_before
		)

	return self
