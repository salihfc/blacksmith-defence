extends Decider
class_name AttackDecider

"""

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
func decide(_caller, _context):
	return Command.new(Command.TYPE.WALK, [Vector2.LEFT])


### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###
