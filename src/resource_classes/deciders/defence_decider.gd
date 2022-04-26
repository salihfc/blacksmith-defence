extends Decider
class_name DefenceDecider

"""
	Players Base Defender AI
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
	return Command.new(Command.TYPE.IDLE)

### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###
