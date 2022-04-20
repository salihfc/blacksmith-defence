extends Sprite

"""

"""

### SIGNAL ###
signal collected(_item)

### ENUM ###


### CONST ###


### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###
var _item

### ONREADY VAR ###


### VIRTUAL FUNCTIONS (_init ...) ###
func _physics_process(_delta):
	if Engine.get_physics_frames() % 5 == 0:
		mouse_check()


### PUBLIC FUNCTIONS ###
func init(_drop_item) -> void:
	_item = _drop_item


func drop() -> void:
	$AnimationPlayer.play("dropping")


func mouse_check() -> void:
	var sprite_size = Vector2(texture.get_width(), texture.get_height())
	var mouse = get_global_mouse_position()
	var rect = Rect2(global_position - sprite_size / 2.0, sprite_size)

	if rect.has_point(mouse):
		emit_signal("collected", _item)  
	

### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###
