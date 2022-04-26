extends Resource
class_name Decider

"""
	Base Class for ai
"""

### SIGNAL ###


### ENUM ###


### CONST ###


### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###


### VIRTUAL FUNCTIONS (_init ...) ###


### PUBLIC FUNCTIONS ###
func decide(_caller : Unit, _context):
	LOG.pr(3, "<ERR> Base Decider called!!", "Decider::decide")
	match _caller.get_state():
		Unit.STATE.IDLE:
			pass
		
		_:
			pass
	
	
	return Command.new(Command.TYPE.IDLE)


### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###
