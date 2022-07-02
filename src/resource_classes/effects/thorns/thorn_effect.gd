extends Effect
class_name ThornEffect
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(float) var reflect_damage

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### PUBLIC FUNCTIONS ###
func trigger(_subject=null, _object=null, _args={}):
	var hit_damage = _args.get('damage', null)
	assert(hit_damage)
	var hit_origin = hit_damage.get_originator()
	assert(hit_origin and hit_origin.has_method('take_damage'))

	hit_origin.take_damage(
		Damage.new(Damage.TYPE.PHYSICAL, reflect_damage).set_originator(_subject)
	)

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###

