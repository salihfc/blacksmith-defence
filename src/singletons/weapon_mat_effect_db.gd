extends Node
"""
"""

### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
var _data = {
	Weapon.TYPE.WAND : {
		MaterialData.TYPE.COPPER : {
			'enhancement' : load("res://tres/unit_enhancements/enh_chain_increase.tres"),
			'hint' : "increase chain count by 1",
		}
	}
}


### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func get_hint(weapon_id : int, mat_id : int) -> String:
	return get_ref(weapon_id, mat_id).get('hint')


func get_enhancement(weapon_id : int, mat_id : int):
	return get_ref(weapon_id, mat_id).get('enhancement')

### PRIVATE FUNCTIONS ###
func get_ref(weapon_id : int, mat_id : int):
	assert(_data)
	var ref = _data.get(weapon_id)
	assert(ref)
	ref = ref.get(mat_id)
	assert(ref)
	return ref

### SIGNAL RESPONSES ###
