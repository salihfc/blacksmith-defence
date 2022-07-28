tool
extends Node
"""
"""
### SIGNAL ###
### ENUM ###
enum TYPE {
	IRON,
	COPPER,

	FIRE,
	EARTH,
	WATER,

	COUNT
}

### CONST ###
export(Dictionary) var WEIGHTS = {
	TYPE.IRON : 100.0,
	TYPE.COPPER : 50.0,
	TYPE.FIRE : 20.0,
	TYPE.EARTH : 20.0,
	TYPE.WATER : 20.0,
}

### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
var _weighted_pool = null

### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	assert(WEIGHTS.size() == TYPE.COUNT)
	_weighted_pool = WeightedPool.new(WEIGHTS)

### PUBLIC FUNCTIONS ###
func get_texture(type : int):
	assert(type < TYPE.COUNT)
	return [
		preload("res://assets/gfx/game/material_sprites/iron.png"),
		preload("res://assets/gfx/game/material_sprites/copper.png"),
		preload("res://assets/gfx/game/material_sprites/fire.png"),
		preload("res://assets/gfx/game/material_sprites/earth.png"),
		preload("res://assets/gfx/game/material_sprites/water.png"),
	][type]


func get_weighted_random():
	return _weighted_pool.get_random()


func get_type_name(type : int) -> String:
	return UTILS.get_enum_string_from_id(TYPE, type)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###

