tool
extends EditorScript

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
func _run():
	var dict = {
		"test" : 1,
		"kek" : 2,
	}

	for item in dict:
		print(item)

	pass
#	var file = File.new()
#	file.open("res://Blacksmith-enemy.csv", File.READ)
#
#	var parsed = file.get_csv_line()
#	var t = 0
#	while parsed and t < 10:
#		print (parsed)
#		parsed = file.get_csv_line()
#		t += 1
#
#	file.close()

### PUBLIC FUNCTIONS ###
### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
