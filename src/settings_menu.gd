extends Control
class_name SettingsMenu
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
onready var tabContainer = $PanelContainer/TabContainer as TabContainer
onready var bgmSlider = $PanelContainer/TabContainer/Sound/VBoxContainer/BGMSlider as SettingSlider
onready var sfxSlider = $PanelContainer/TabContainer/Sound/VBoxContainer/SFXSlider as SettingSlider

### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:

	# Tab Title adjusment
	for _i in tabContainer.get_child_count():
		var title = tabContainer.get_tab_title(_i)
		tabContainer.set_tab_title(_i, UTILS.wrap_str(title, " ", " "))

	bgmSlider.silent_config(AUDIO.bgm_on, AUDIO.default_bgm_volume)
	sfxSlider.silent_config(AUDIO.sfx_on, AUDIO.default_sfx_volume)

	bgmSlider.set_option(
		"Background music",
		preload("res://assets/gfx/ui/bgm_icon.png"),
		0.0
	)

	sfxSlider.set_option(
		"Sound effects",
		preload("res://assets/gfx/ui/sfx_icon.png"),
		0.0
	)

	SIGNAL.bind_multi(
		[
			[bgmSlider, "option_value_changed", self, "_on_bgm_volume_changed"],
			[bgmSlider, "enabled", self, "_on_bgm_enabled"],

			[sfxSlider, "option_value_changed", self, "_on_sfx_volume_changed"],
			[sfxSlider, "enabled", self, "_on_sfx_enabled"],
		]
	)

### PUBLIC FUNCTIONS ###
### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###



func _on_TabContainer_tab_changed(_tab: int) -> void:
	AUDIO.play_ui_sfx(AUDIO.UI_SFX.PRESS_BLIP)



# warning-ignore:unused_argument
func _on_bgm_volume_changed(new_volume_frac) -> void:
	AUDIO.set_bgm_volume(new_volume_frac)


func _on_bgm_enabled(enable) -> void:
	AUDIO.enable_bgm(enable)


# warning-ignore:unused_argument
func _on_sfx_volume_changed(new_volume_frac) -> void:
	AUDIO.set_sfx_volume(new_volume_frac)


func _on_sfx_enabled(enable) -> void:
	AUDIO.enable_sfx(enable)
