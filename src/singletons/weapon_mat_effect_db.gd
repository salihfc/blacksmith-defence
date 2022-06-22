tool
extends Node
"""
"""

### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
var _owners = {}
var _data = {}
var _default_data = {
####################################
	"SWORD" : {
		"IRON" : {
			'enhancement' : UnitEnhancementStat.new(StatContainer.STATS.BASE_DAMAGE, 10),
			'hint' : "increase damage by 10",
		},
	},

####################################
	"RAPIER" : {
		"IRON" : {
			'enhancement' : UnitEnhancementStat.new(StatContainer.STATS.BASE_DAMAGE, 10),
			'hint' : "increase damage by 10",
		},
	},

####################################
	"WAND" : {
		"IRON" : {
			'enhancement' : UnitEnhancementStat.new(StatContainer.STATS.BASE_DAMAGE, 10),
			'hint' : "increase damage by 10",
		},

		"COPPER" : {
			'enhancement' : UnitEnhancementStat.new(StatContainer.STATS.CHAIN_COUNT, 1),
			'hint' : "increase chain count by 1",
		},

		"FIRE" : {
			'enhancement' : UnitEnhancementStatusChanceOnHit.new(
				1.0,
				STATUS.create_status(StatusEffect.TYPE.POISON, 2.0, 0.0)
			),
			'hint' : "100% chance to poison on hit",
		},

		"EARTH" : {
			'enhancement' : UnitEnhancementStat.new(
				StatContainer.STATS.SPELL_AOE,
				1.0
			),
			'hint' : "increase spell area of effect by 100%",
		},
	},
}

### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
func _init() -> void:
	if _owners == null:
		_owners = {}

	for weapon_name in Weapon.TYPE.keys():
		if not weapon_name in _owners:
			_owners[weapon_name] = null

	if _data == null:
		_data = {}

	for weapon_name in Weapon.TYPE.keys():
		if not weapon_name in _data:
			_data[weapon_name] = {}

		for mat_name in MaterialData.TYPE.keys():
			if not mat_name in _data[weapon_name]:
				if _default_data.get(weapon_name) and _default_data[weapon_name].get(mat_name):
					_data[weapon_name][mat_name] = _default_data[weapon_name][mat_name]
				else:
					_data[weapon_name][mat_name] = {}

	UTILS.pretty_print(_data)


func _parse_property(property: String):
	return property.to_upper().split("/", false)


func _get(property: String):
	# weapon_name/mat_name
	# 'owner'/weapon_name
	if property.count('/'):
		var path = _parse_property(property)
		if path.size() == 2:

			if path[0].to_lower() == 'owner':
				return _owners.get(path[1])
			else:
				var weapon_name = path[0]
				var mat_name = path[1]
				assert(weapon_name != null)
				assert(mat_name != null)

				return get_enhancement(weapon_name, mat_name)


func _set(property: String, value = false) -> bool:
	if property.count('/'):
		var path = _parse_property(property)
		if path.size() == 2:
			if path[0].to_lower() == 'owner':
#				prints('set owner', path[1])
				_owners[path[1]] = value
			else:
				var weapon_name = path[0]
				var mat_name = path[1]
				set_enhancement(weapon_name, mat_name, value)
	property_list_changed_notify()
	return true


func _get_property_list() -> Array:
	var props = []

	for weapon_name in Weapon.TYPE.keys():
		if not weapon_name in _owners:
			_owners[weapon_name] = null

		props.append(
			{
				'name' : 'owner' + "/" + weapon_name,
				'type' : TYPE_OBJECT,
				'hint' : PROPERTY_HINT_RESOURCE_TYPE,
			}
		)

	for weapon_name in Weapon.TYPE.keys():
		if not weapon_name in _data:
			_data[weapon_name] = {}

		for mat_name in MaterialData.TYPE.keys():
			if not mat_name in _data[weapon_name]:
				if _default_data.get(weapon_name) and _default_data[weapon_name].get(mat_name):
					_data[weapon_name][mat_name] = _default_data[weapon_name][mat_name]
				else:
					_data[weapon_name][mat_name] = {}

			props.append(
				{
					'name' : weapon_name + "/" + mat_name,
					'type' : TYPE_OBJECT,
					'hint' : PROPERTY_HINT_RESOURCE_TYPE,
					'hint_string' : 'UnitEnhancementBase',
				}
			)
#	print (_data)
	return props



### PUBLIC FUNCTIONS ###
func get_hint(weapon_name : String, mat_name : String) -> String:
	assert(_data)
	var ref = _data.get(weapon_name)
	assert(ref != null)
	ref = ref.get(mat_name)
	assert(ref != null)
	return ref.get('hint')


func get_enhancement(weapon_name : String, mat_name : String):
	weapon_name = weapon_name.to_upper()
	mat_name = mat_name.to_upper()

	assert(_data)
	var ref = _data.get(weapon_name)

#	if ref == null:
#		print (weapon_name)
	assert(ref != null)
	ref = ref.get(mat_name)
	assert(ref != null)
	return ref.get('enhancement')


func set_enhancement(weapon_name : String, mat_name : String, enhancement):
	assert(_data)
	var ref = _data.get(weapon_name)
	assert(ref != null)
	ref = ref.get(mat_name)
	assert(ref != null)
	ref['enhancement'] = enhancement

### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###
