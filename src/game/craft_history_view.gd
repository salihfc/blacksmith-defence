tool
extends Panel
class_name CraftHistoryView
func get_base(): return "Panel"
func get_class(): return "CraftHistoryView"
func is_class(_name): return _name == get_class() or .is_class(_name)
"""
"""
### SIGNAL ###
### ENUM ###
### CONST ###
### EXPORT ###
export(PackedScene) var P_UnitRecipeView

export(int) var history_size = 5

### PUBLIC VAR ###
### PRIVATE VAR ###
### ONREADY VAR ###
onready var recipes = $HBoxContainer/Recipes
onready var temp = $HBoxContainer/TempRecipeContainer

### VIRTUAL FUNCTIONS (_init ...) ###
### PUBLIC FUNCTIONS ###
func clear():
	UTILS.clear_children(recipes)
	return self


func add_recipe_view(recipe):
	assert(recipes.get_child_count() <= history_size)

	if recipes.get_child_count() == history_size:
		var last_child = recipes.get_children()[-1]
		recipes.remove_child(last_child)
		last_child.queue_free()

	var view = P_UnitRecipeView.instance().set_data_pre(recipe)
	recipes.add_child(view)
	recipes.move_child(view, 0)
	return view

### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
func _on_Button_pressed() -> void:

	if recipes.visible:
		recipes.visible = false
		for child in recipes.get_children():
			recipes.remove_child(child)
			temp.add_child(child)

	else:
		recipes.visible = true
		_transfer_recipe()

#	$HBoxContainer/HBoxContainer2.visible = not $HBoxContainer/HBoxContainer2.visible


func _transfer_recipe() -> void:
	if temp.get_child_count():
		var ch = temp.get_child(0)
		temp.remove_child(ch)
		recipes.add_child(ch)

		TWEEN.interpolate_callback(
			self, "_transfer_recipe", 0.05
		)
