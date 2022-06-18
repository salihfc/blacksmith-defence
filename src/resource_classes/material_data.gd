tool
extends Resource
class_name MaterialData
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
}

### CONST ###
const sprite_path = "res://assets/gfx/game/material_sprites/"
### EXPORT ###
export(Texture) var sprite

var type setget set_type
var name setget set_name

func set_type(_type):
	type = _type

	if type != null:
		name =  TYPE.keys()[type] # update name
		sprite = load(sprite_path + name.to_lower() + ".png")
	emit_changed()
	property_list_changed_notify() # MAKE SURE EDITOR UPDATES!!


func set_name(_name):
	name = _name


func get_name():
	return name


func _get(property: String):
	match property:
		"type":
			return type
		"name":
			return name


func _set(property: String, value) -> bool:
	prints (property, value)
	match property:
		"type":
			type = value
			print ("setting type to [%s]" % [value])
			return true

	return false


func _get_property_list() -> Array:
	var props = []
	props.append_array(
		[
			{
				'name' : "type",
				'type' : TYPE_INT,
				'hint' : PROPERTY_HINT_ENUM,
				'hint_string' : UTILS.get_enum_hint_string(TYPE),
				'property_usage' : PROPERTY_USAGE_DEFAULT
								| PROPERTY_USAGE_SCRIPT_VARIABLE
								| PROPERTY_USAGE_CHECKED,
			},
			{
				'name' : "name",
				'type' : TYPE_STRING,
				'property_usage' : PROPERTY_USAGE_DEFAULT
								| PROPERTY_USAGE_SCRIPT_VARIABLE
								| PROPERTY_USAGE_CHECKED,
			},
		]
	)
	return props

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _init(mat_type : int = 0) -> void:
	set_type(mat_type)


func _to_string() -> String:
	return name

### PUBLIC FUNCTIONS ###


### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
