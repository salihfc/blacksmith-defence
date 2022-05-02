extends IAUSObject
class_name Agent

"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###


### EXPORT ###
export(Array, Resource) var _actions = []

### PUBLIC VAR ###


### PRIVATE VAR ###
var _eval_cache = CacheDict.new()

### ONREADY VAR ###


### VIRTUAL FUNCTIONS (_init ...) ###


### PUBLIC FUNCTIONS ###
func decide_action(context, actor, possible_targets) -> Action:
	_eval_cache.clear()

	var max_utility = -1.0
	var best_action = null
	
	LOG.pr(1, "Actor (%s) deciding" % [actor])
	
	for action in _actions:
		var action_utility = -INF

		match action.action_type:
			IAUS.ACTION.IDLE, IAUS.ACTION.WALK_TOWARDS_ENEMY_BASE:
				action_utility = action.score(context, actor)
				_eval_cache.cache([action], action_utility)
			
			_:
				var target_utility = -INF
				for target in possible_targets:
					var new_target_utility = action.score(context, actor, target)
					_eval_cache.cache([action, target], new_target_utility)
					LOG.pr(1, "[%s -> %s]: %f" % [actor, target, new_target_utility])
					if new_target_utility > target_utility:
						target_utility = new_target_utility
						action.target = target
				
				action_utility = target_utility


		if action_utility > max_utility:
			max_utility = action_utility
			best_action = action
	LOG.pr(1, "----------------")
	return best_action


func get_eval_cache():
	return _eval_cache


### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###
