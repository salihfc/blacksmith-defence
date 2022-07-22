tool
extends Effect
class_name BerserkEffect
func get_base(): return "Effect"
func get_class(): return "BerserkEffect"
func is_class(_class_name): return _class_name == get_class() or .is_class(_class_name)
func _to_string(): return "[%s :: %s]" % [get_class(), resource_path]
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(float) var berserk_damage_multi = 1.5

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func trigger(_subject=null, _object=null, _args={}):
	LOG.pr(LOG.LOG_TYPE.INTERNAL, "BerserkEffect > working")
	if _subject is EnemyUnit:
		_subject.multiply_stat(StatContainer.STATS.DAMAGE_MULTI, berserk_damage_multi)


### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###

