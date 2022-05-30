extends Sprite
class_name PlayerBase

"""

"""

### SIGNAL ###
signal base_taken_damage(damage)

### ENUM ###


### CONST ###


### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###


### VIRTUAL FUNCTIONS (_init ...) ###
func _ready():
	add_to_group("player_unit")
	
	for child in $Randomized.get_children():
		if child is Sprite:
			if randf() > 0.5:
				child.visible = false
			else:
				child.offset += UTILS.random_unit_vec2() * rand_range(0.2, 1.6)


### PUBLIC FUNCTIONS ###
func take_damage(_damage : Damage) -> void:
	LOG.pr(LOG.LOG_TYPE.GAMEPLAY, "[%s] taking %s" % [self, _damage])
	emit_signal("base_taken_damage", _damage)


### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###
