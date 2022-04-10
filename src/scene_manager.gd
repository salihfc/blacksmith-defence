extends CanvasLayer

"""

"""

### SIGNAL ###


### ENUM ###
enum SCENE {
	TEST
}

const SCENES = {
}


### CONST ###
const DEFAULT_FOREGROUND_COLOR = Color("0c0d1d")
const FULL_TRANSPARENT = Color(0.0, 0.0, 0.0, 0.0)
const FADE_MIN_DELAY = 0.1
const RECOVERY_MIN_DELAY = 0.5


### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###
onready var foreground = $Control/Foreground as ColorRect
onready var sceneSlot = $CurrentSceneSlot as Control


### VIRTUAL FUNCTIONS (_init ...) ###

func _ready() -> void:
	LOG.pr(3, "READY", "SCENE_MANAGER")
	set_foreground_color(DEFAULT_FOREGROUND_COLOR)


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
