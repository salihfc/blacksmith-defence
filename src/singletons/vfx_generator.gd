extends Node2D

"""

"""

### SIGNAL ###
signal vfx_created(vfx)
### ENUM ###
enum FX {
	SWING_HIT_PARTICLES,
	THRUST_HIT_PARTICLES,
	
	BLOOD_EXPLOSION_PARTICLES,
}

### CONST ###


### EXPORT ###
export(PackedScene) var VFX_SWING_HIT
export(PackedScene) var VFX_THRUST_HIT
export(PackedScene) var VFX_BLOOD
### PUBLIC VAR ###
onready var _effects = {
	FX.SWING_HIT_PARTICLES : VFX_SWING_HIT,
	FX.THRUST_HIT_PARTICLES : VFX_THRUST_HIT,
	FX.BLOOD_EXPLOSION_PARTICLES : VFX_BLOOD
}

### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func generate_fx_at(fx_id : int, global_pos : Vector2, delay := 0.0) -> void:
	assert(fx_id in _effects)
	LOG.pr(3, "Generate VFX [%s] at [%s]" % [UTILS.get_enum_string_from_id(FX, fx_id), global_pos])
	var fx = _effects[fx_id].instance()
	emit_signal("vfx_created", fx)
	fx.global_position = global_pos
	
	yield(get_tree().create_timer(delay), "timeout")
	fx.emit()


### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###