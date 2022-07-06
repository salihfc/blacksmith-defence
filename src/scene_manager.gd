extends CanvasLayer
class_name SceneManager

"""

"""

### SIGNAL ###


### ENUM ###
enum SCENE {
	MAIN_MENU,
	SETTINGS,

	GAME,
}

const SCENES = {
	SCENE.MAIN_MENU : preload("res://src/main_menu.tscn"),
	SCENE.SETTINGS : preload("res://src/settings_menu.tscn"),
	SCENE.GAME : preload("res://src/game/game.tscn"),
}


### CONST ###
const DEFAULT_FOREGROUND_COLOR = Color("0c0d1d")
const FULL_TRANSPARENT = Color(0.0, 0.0, 0.0, 0.0)
const FADE_MIN_DELAY = 0.1
const RECOVERY_MIN_DELAY = 0.5

export(SCENE) var STARTING_SCENE = SCENE.MAIN_MENU
### EXPORT ###
export(Texture) var mouse_normal_cursor
export(Texture) var mouse_pressed_cursor

### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###
onready var foreground = $Control/Foreground as ColorRect
onready var sceneSlot = $CurrentSceneSlot as Control


### VIRTUAL FUNCTIONS (_init ...) ###
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				Input.set_custom_mouse_cursor(mouse_pressed_cursor)
			else:
				Input.set_custom_mouse_cursor(mouse_normal_cursor)


func _ready() -> void:
	add_to_group(str(GROUP.SCENE_MANAGER))
	randomize()
	LOG.pr(LOG.LOG_TYPE.INTERNAL, "READY", "SCENE_MANAGER")
	set_foreground_color(DEFAULT_FOREGROUND_COLOR)
	Input.set_custom_mouse_cursor(mouse_normal_cursor)
	change_scene(STARTING_SCENE)


### PUBLIC FUNCTIONS ###
func set_foreground_color(new_color : Color) -> void:
	foreground.color = new_color


func change_scene(scene_id) -> void:
	fade(1.0, FADE_MIN_DELAY)
	if sceneSlot.get_child_count():
		var current_scene = sceneSlot.get_child(0)
		current_scene.queue_free()

	var scene = SCENES[(scene_id)].instance()
	scene.visible = false
	sceneSlot.add_child(scene)

	# TODO: Should wait until scene fully loaded
	yield(get_tree().create_timer(1.0), "timeout")
	bind_ui_buttons()
	fade(0.0, RECOVERY_MIN_DELAY)
	scene.visible = true


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
			]
		)

	return self
