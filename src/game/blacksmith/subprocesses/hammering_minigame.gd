extends Control

"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###
const DEFAULT_TEXTURE = preload("res://assets/gfx/common/64x64_white.png")

const TARGET_COLOR = Color.forestgreen
const TARGET_COUNT = 3
const MIN_TARGET_SIZE = 20
const MAX_TARGET_SIZE = 60

### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###
onready var targetContainer = $Targets as Control
onready var pointer = $Pointer as TextureRect

### VIRTUAL FUNCTIONS (_init ...) ###
func _ready():
	create_random_targets()
	start_pointer_movement()


### PUBLIC FUNCTIONS ###
func create_random_targets() -> void:
	var p_size = 1.0 / float(TARGET_COUNT)
	for i in TARGET_COUNT:
		var target_pos_p = rand_range(i*p_size, (i+1) * p_size)
		var target_size = rand_range(MIN_TARGET_SIZE, MAX_TARGET_SIZE)
		
		LOG.pr(1, "[%s], [%s]" % [target_pos_p, target_size])

		var new_target = TextureRect.new()
		new_target.expand = true
		new_target.texture = DEFAULT_TEXTURE
		new_target.self_modulate = TARGET_COLOR
		
		new_target.rect_size = Vector2(target_size, get_rect().size.y)
		new_target.rect_global_position =\
				Vector2(get_rect().size.x * target_pos_p - target_size / 2, 0.0)

		targetContainer.add_child(new_target)



func start_pointer_movement() -> void:
	TWEEN.interpolate_property(
			pointer, "rect_global_position:x",
			0.0, rect_size.x,
			2.0,
			Tween.TRANS_LINEAR)
	
	pass

### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###
