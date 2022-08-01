extends Node

onready var BGMplayer  = get_node("BGMPlayer")
onready var SFXplayers = get_node("SFXPlayers")
onready var BattleSFXplayers = get_node("BattleSFXPlayers")

const BGM_BUS = "BGM"
const SFX_BUS = "SFX"
const BATTLE_SFX_BUS = "SFX_BATTLE"

export(AudioStream) var BGM_MENU
export(AudioStream) var BGM_BATTLE
export(int) var sfx_player_count := 8
export(float, 0.0, 1.0, 0.01) var default_bgm_volume = 0.0
export(float, 0.0, 1.0, 0.01) var default_sfx_volume = 0.0
export(bool) var bgm_on = false setget enable_bgm
export(bool) var sfx_on = true

enum BGM {
	MENU,
	BATTLE,
}

enum UI_SFX {
	HOVER_BLIP,
	PRESS_BLIP,

	CLICK_DUST,
	UNIT_PLACEMENT

	COUNT,
}

const UI_SFX_ARRAY = [
	preload("res://assets/sfx/ui/ui_hover_blip.wav"),
	preload("res://assets/sfx/ui/ui_press_blip-2.wav"),

	preload("res://assets/sfx/ui/dust_sound.wav"),
	preload("res://assets/sfx/ui/unit_placement_sound.wav"),
]

enum SFX {
	SPELL_ARC,
	SPELL_ICENOVA,

	WEAPON_SWORD_SWING,
	WEAPON_RAPIER_THRUST,

	COUNT,
}

const SFX_start = {
}

const SFX_array = [
	preload("res://assets/sfx/spells/arc/SFX_zap.wav"),
	preload("res://assets/sfx/spells/ice-nova/SFX_double_whoosh2.wav"),

	preload("res://assets/sfx/sword/m_SFX_Sword_Draw_and_Swing_01.wav"),
	preload("res://assets/sfx/rapier/SFX_Dagger_Draw_and_Whoosh_02.wav"),
]

func _ready() -> void:
	LOG.pr(LOG.LOG_TYPE.INTERNAL, "READY", "AUDIO")
	set_sfx_player_count(sfx_player_count, SFXplayers)
	set_sfx_player_count(sfx_player_count, BattleSFXplayers)

	BGMplayer.bus = BGM_BUS
	BGMplayer.stream = AudioStreamRandomPitch.new()

	set_sfx_volume(default_sfx_volume)
	set_bgm_volume(default_bgm_volume)


func enable_bgm(on : bool = true):
	bgm_on = on
	__mute_bus(BGM_BUS, not on)

	if bgm_on and BGMplayer and not BGMplayer.playing:
		BGMplayer.play()

	return self


func enable_sfx(on : bool = true):
	sfx_on = on
	__mute_bus(SFX_BUS, not on)
	return self


func set_bgm_volume(volume : float) -> void:
	assert(0.0 <= volume and volume <= 1.0)
	__set_bus_volume(BGM_BUS, volume)


func get_bgm_volume() -> float: # [0..1]
	return __get_bus_volume(BGM_BUS)


func set_sfx_volume(volume : float) -> void:
	assert(0.0 <= volume and volume <= 1.0)
	__set_bus_volume(SFX_BUS, volume)
	LOG.pr(LOG.LOG_TYPE.SFX, "bus set to [%s]" % [AudioServer.get_bus_volume_db(AudioServer.get_bus_index(SFX_BUS))])


func get_sfx_volume() -> float: # [0..1]
	return __get_bus_volume(SFX_BUS)



func play_bgm(bgm_id) -> void:
	if bgm_on:
		var bgm = null
		match bgm_id:
			BGM.MENU:
				bgm = BGM_MENU

			BGM.BATTLE:
				bgm = BGM_BATTLE

		if bgm and bgm != BGMplayer.stream.audio_stream:
			BGMplayer.stream.audio_stream = bgm
			BGMplayer.play()


func play(sfx_id : int) -> void:
#	LOG.pr(LOG.LOG_TYPE.SFX, "play sfx: [%s]" % [sfx_id])
	if sfx_on:
		_play_sfx(SFX_array[sfx_id], BattleSFXplayers)


func play_ui_sfx(sfx_id : int) -> void:
#	LOG.pr(LOG.LOG_TYPE.SFX, "play sfx: [%s]" % [sfx_id])
	_play_sfx(UI_SFX_ARRAY[sfx_id], SFXplayers)


func _play_sfx(sfx_audio, player_container):
	if sfx_on:
		for SFXplayer in player_container.get_children():
			if not SFXplayer.is_playing():
				SFXplayer.stream.audio_stream = sfx_audio
				SFXplayer.play()
				break



func get_sfx_bus(player_container):
	match player_container:
		BattleSFXplayers:
			return BATTLE_SFX_BUS
		SFXplayers:
			return SFX_BUS
	assert(0)


func set_sfx_player_count(count : int, player_container) -> void:
	var delta = count - player_container.get_child_count()
	if delta > 0: # Add new
		for _i in range(delta):
			var new_player = AudioStreamPlayer.new()
			new_player.bus = get_sfx_bus(player_container)
			new_player.stream = AudioStreamRandomPitch.new()
			player_container.add_child(new_player)
	elif delta < 0:
		var sfx_players = player_container.get_children()
		for _i in range(-delta):
			var last = sfx_players.back()
			sfx_players.pop_back()

			player_container.remove_child(last)
			last.queue_free()


func _on_BGMPlayer_finished() -> void:
	if bgm_on:
		BGMplayer.play()


### PRIVATE
func __mute_bus(bus_name, mute) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index(bus_name), mute)


func __set_bus_volume(bus_name, volume_frac) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear2db(volume_frac))


func __get_bus_volume(bus_name) -> float:
	var db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index(bus_name))
	return db2linear(db)

###
