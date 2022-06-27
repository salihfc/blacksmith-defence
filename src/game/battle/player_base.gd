extends Sprite
class_name PlayerBase
"""
"""
### SIGNAL ###
signal base_taken_damage(damage)

### ENUM ###
### CONST ###
### EXPORT ###
export(bool) var light_on = true

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
onready var randomizable_visuals = $Randomized

### VIRTUAL FUNCTIONS (_init ...) ###
func _ready():
	add_to_group("player_unit")

	for child in randomizable_visuals.get_children():
		if child is Sprite:
			if randf() > 0.5:
				child.visible = false
			else:
				child.offset += UTILS.random_unit_vec2() * rand_range(0.2, 1.6)

	$Sprite7/Light2D.visible = light_on

### PUBLIC FUNCTIONS ###
func take_damage(_damage) -> void:
	LOG.pr(LOG.LOG_TYPE.GAMEPLAY, "[%s] taking %s" % [self, _damage])
	emit_signal("base_taken_damage", _damage)
	VFX.generate_fx_at(VFX.FX.BASE_SPLINTERS, global_position)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
