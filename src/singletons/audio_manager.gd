extends Node

onready var BGMplayer  = get_node("BGMPlayer")
onready var SFXplayers = get_node("SFXPlayers")

export(AudioStream) var BGM
export(int) var sfx_player_count := 8
export(float, 0.0, 1.0, 0.01) var default_bgm_volume = 0.0
export(float, 0.0, 1.0, 0.01) var default_sfx_volume = 0.0

# For safety
const MIN_VOLUME_DB := -60.0
const MAX_VOLUME_DB := 0.0
const VOLUME_REDUCTION_DB := 30.0

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

var bgm_on = false
var bgm_linear = 0

var sfx_on = true
var sfx_linear = 0


func _ready() -> void:
	LOG.pr(LOG.LOG_TYPE.INTERNAL, "READY", "AUDIO")
	set_sfx_player_count(sfx_player_count)

	BGMplayer.stream = AudioStreamRandomPitch.new()
	BGMplayer.stream.audio_stream = BGM

	set_sfx_volume(default_sfx_volume)
	set_bgm_volume(default_bgm_volume)

	if bgm_on:
		BGMplayer.play()


func set_bgm_volume(new_value : float) -> void:
	bgm_linear = new_value
	_set_audio_stream_db(BGMplayer, linear2db(bgm_linear))


func set_sfx_volume(new_value : float) -> void:
	sfx_linear = new_value
	var db_eq = linear2db(sfx_linear)
	LOG.pr(LOG.LOG_TYPE.SFX, "Set SFX volume: (%s), (%s)" % [new_value, db_eq])
	for SFXplayer in SFXplayers.get_children():
		_set_audio_stream_db(SFXplayer, db_eq)



func play(sfx_id : int) -> void:
	LOG.pr(LOG.LOG_TYPE.SFX, "play sfx: [%s]" % [sfx_id])
	if sfx_on and sfx_id < SFX_array.size():
		for SFXplayer in SFXplayers.get_children():
			if not SFXplayer.is_playing():
#				LOG.pr(LOG.LOG_TYPE.SFX, "PLAYING SFX::(%s)" % [sfx_id])
				SFXplayer.stream.audio_stream = SFX_array[sfx_id]
				SFXplayer.play(SFX_start[sfx_id] if SFX_start.has(sfx_id) else 0)
				break


func set_sfx_player_count(count : int) -> void:
	var delta = count - SFXplayers.get_child_count()

	if delta > 0: # Add new
		for _i in range(delta):
			var new_player = AudioStreamPlayer.new()
			new_player.stream = AudioStreamRandomPitch.new()
			_set_audio_stream_db(new_player, default_sfx_volume)

			SFXplayers.add_child(new_player)

	elif delta < 0:
		var sfx_players = SFXplayers.get_children()
		for _i in range(-delta):
			var last = sfx_players.back()
			sfx_players.pop_back()

			SFXplayers.remove_child(last)
			last.queue_free()



func _on_BGMPlayer_finished() -> void:
	if bgm_on:
		BGMplayer.play()



func _set_audio_stream_db(stream_node, db) -> void:
	db = clamp(db, -60.0 - max(0, VOLUME_REDUCTION_DB), 0.0 - max(0, VOLUME_REDUCTION_DB))
	LOG.pr(LOG.LOG_TYPE.SFX, "SET audio stream[%s] volume [%s]" % [stream_node, db])
	stream_node.volume_db = db
