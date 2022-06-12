extends PanelContainer

"""

"""

### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
onready var cols = $HBoxContainer as HBoxContainer
### VIRTUAL FUNCTIONS (_init ...) ###


### PUBLIC FUNCTIONS ###
func fill_with(arr) -> void:
#	var flat_arr = UTILS.flatten_array(arr)
	var flat_arr = arr
	print (flat_arr)

	for item in flat_arr:
		var label = Label.new()
		label.text = str(item)
		cols.add_child(label)


### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
