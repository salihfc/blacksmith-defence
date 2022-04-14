extends Panel

"""

"""

### SIGNAL ###
signal player_defeated()

### ENUM ###


### CONST ###


### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###
onready var battleWorld = $ViewportContainer/Viewport/BattleWorld as Node2D

onready var playerBaseHpBar =\
	$UI/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/MarginContainer/PanelContainer/PlayerBaseHpBar as TextureProgress

onready var craftedItemContainer =\
	$UI/VBoxContainer/PanelContainer2/MarginContainer/ScrollContainer/CraftedItemContainer as HBoxContainer

onready var playerUnitSpawningRects = $UI/VBoxContainer/OverBattle/PlayerUnitSpawningRects as Control
onready var draggedItem = $UI/DraggedItem as Control


### VIRTUAL FUNCTIONS (_init ...) ###
func _ready():
	UTILS.bind(
		battleWorld, "base_hp_updated",
		self, "_on_base_hp_updated"
	)

	UTILS.bind(
		battleWorld, "player_base_destroyed",
		self, "_on_player_base_destroyed"
	)


func _process(_delta) -> void:
	var dragged_item = get_dragged_item()
	if dragged_item:
		dragged_item.rect_global_position = get_global_mouse_position()


### PUBLIC FUNCTIONS ###
func show_spawn_rects(_show := true) -> void:
	playerUnitSpawningRects.visible = _show


func get_dragged_item():
	if draggedItem.get_child_count():
		return draggedItem.get_child(0)
	return null


func drop_dragged_item():
	for item in draggedItem.get_children():
		draggedItem.remove_child(item)
		item.queue_free()

### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###
func _on_base_hp_updated(_hp, _max_hp) -> void:
	playerBaseHpBar.value = (100.0) * (_hp / _max_hp)


func _on_player_base_destroyed() -> void:
	emit_signal("player_defeated")


func _on_item_created(item) -> void:
	var new_button = TextureButton.new()
	new_button.texture_normal = item.texture
	new_button.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	craftedItemContainer.add_child(new_button)

	UTILS.bind(
		new_button, "button_down",
		self, "_on_started_dragging_item",
		[item]
	)
	
	UTILS.bind(
		new_button, "button_up",
		self, "_on_stopped_dragging_item",
		[item, new_button]
	)


func _on_started_dragging_item(item) -> void:
	if get_dragged_item() == null:
		var drag_item = TextureRect.new()
		drag_item.stretch_mode = TextureRect.STRETCH_SCALE
		drag_item.texture = item.texture
		show_spawn_rects()
		draggedItem.add_child(drag_item)


func _on_stopped_dragging_item(_item, _new_button) -> void:
	var dragged_item = get_dragged_item()
	if dragged_item:
		for spawning_rect in playerUnitSpawningRects.get_children():
			if dragged_item.get_global_rect().intersects(spawning_rect.get_global_rect()):
				var lane = spawning_rect.get_index()
				LOG.pr(1, "Spawn player unit in lane [%s]" % [lane])
				battleWorld.spawn_player_unit_with_item(_item, lane)
				_new_button.queue_free()
				break

		drop_dragged_item()
	show_spawn_rects(false)
