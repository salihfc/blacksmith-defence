#extends Control
extends Node2D
# TODO:
#		[+] Integrate CraftingMenu
#		[+] Update Unit List to have be a list of crafted/craftable unit recipes
#		- Add option to hide uncraftable recipes

### SIGNAL ###
signal material_used(mat, count)

### ENUM ###
### CONST ###
# Prefabs
### EXPORT ###
#export(Texture) var mouse_normal_cursor
#export(Texture) var mouse_pressed_cursor

"""
	NOTE:
	Only export NodePaths when the scene structure is deep to prevent
	very long, ugly looking paths after '$'
"""
export(NodePath) var NP_Battle
export(NodePath) var NP_MaterialList
export(NodePath) var NP_UnitRecipeList
export(NodePath) var NP_DebugWindow
export(NodePath) var NP_CraftingMenu
export(NodePath) var NP_CraftingPopupPanel
export(NodePath) var NP_StartButton
export(NodePath) var NP_CraftButton
export(NodePath) var NP_BaseHealthBar

export(NodePath) var NP_WaveCounter
export(NodePath) var NP_ScreenTextCreator

export(NodePath) var NP_UnitInfoPopupPanel
export(NodePath) var NP_UnitInfoDisplay

export(NodePath) var NP_ExitConfirmationDialog

export(NodePath) var NP_GameOverPopup
export(NodePath) var NP_GameOverDialog

export(Resource) var unit_data_pool = null
export(Resource) var player_base = null

### PUBLIC VAR ###
var player_material_storage = MaterialCost.new()

### PRIVATE VAR ###
var _player_lost = false

var _cached_recipes = [
	UnitRecipe.new(
		preload("res://tres/units/player_units/Duelist.tres"),
		MaterialCost.new()\
			.add_material(MAT.TYPE.FIRE, 1)\
			.add_material(MAT.TYPE.EARTH, 1)\
			.add_material(MAT.TYPE.COPPER, 1)\
	),

	UnitRecipe.new(
		preload("res://tres/units/player_units/Arcanist.tres"),
		MaterialCost.new().add_material(MAT.TYPE.FIRE, 1)
	),
]

### ONREADY VAR ###
onready var battle = get_node(NP_Battle)
onready var materialList = get_node(NP_MaterialList)
onready var unitRecipeList = get_node(NP_UnitRecipeList)
onready var debugWindow = get_node(NP_DebugWindow)
onready var craftingMenu = get_node(NP_CraftingMenu)
onready var craftingPopup = get_node(NP_CraftingPopupPanel) as PopupPanel
onready var startWaveButton = get_node(NP_StartButton)
onready var craftButton = get_node(NP_CraftButton)
onready var baseHealthBar = get_node(NP_BaseHealthBar)

onready var unitInfoPopupPanel = get_node(NP_UnitInfoPopupPanel) as PopupPanel
onready var unitInfoDisplay = get_node(NP_UnitInfoDisplay) as UnitInfoDisplay
onready var exitConfirmationDialog = get_node(NP_ExitConfirmationDialog) as ConfirmationDialog

onready var gameOverPopup = get_node(NP_GameOverPopup) as PopupPanel
onready var gameOverDialog = get_node(NP_GameOverDialog) as GameOverDialog

onready var waveCounter = get_node(NP_WaveCounter) as WaveCounter
onready var screenTextCreator = get_node(NP_ScreenTextCreator) as ScreenTextCreator

### VIRTUAL FUNCTIONS (_init ...) ###
func _input(event):
	if GROUP.get_global(GROUP.SCENE_MANAGER).is_loading():
		return

	if event is InputEventKey and event.pressed:

		match event.scancode:
			KEY_QUOTELEFT: # Toggle DebugWindow
				pass
#				debugWindow.visible = !debugWindow.visible

			KEY_SPACE: # Wave start shortcut
				if OS.is_debug_build():
					_on_wave_start_button_pressed()
					screenTextCreator.create_gratz_text(_get_center(), "Wave started")

			KEY_P: # Pause with P
				LOG.pr(LOG.LOG_TYPE.INTERNAL, "PAUSED")
				_pause_battle()

			KEY_A: # Toggle Circles with A
				if OS.is_debug_build():
					CONFIG.SHOW_RANGE_CIRCLES = not CONFIG.SHOW_RANGE_CIRCLES

			KEY_S:
				if OS.is_debug_build():
					player_base.take_damage(Damage.new(Damage.TYPE.PHYSICAL, 100.0))

			KEY_ESCAPE:
				# Game scene overwrites the effect of ESCAPE KEY
				# To prevent SceneManager::_unhandled_input from processing this input
				# mark it handled
				get_tree().set_input_as_handled()
				#

				if craftingPopup.visible:
					_on_crafting_cancelled()
				else:
					LOG.pr(LOG.LOG_TYPE.INTERNAL, "Confirm Exit?")
					_pause_battle()
					exitConfirmationDialog.popup_centered()


func _ready():
#	get_viewport().world = preload("res://battle_env.world")

	GROUP.set_global(GROUP.GAME, self)
	GROUP.set_global(GROUP.PLAYER_MATS, player_material_storage)
	# Init Player Base
	assert(player_base)
	player_base.init()

	SIGNAL.bind_multi([
		[player_base, "player_main_base_destroyed", self, "_on_player_main_base_destroyed"],
		[player_base, "hp_updated", baseHealthBar, "_on_value_updated"],

		[startWaveButton, "pressed", self, "_on_wave_start_button_pressed"],
		[craftButton, "pressed", self, "_on_CraftButton_pressed"],
		[exitConfirmationDialog, "confirmed", self, "_go_to_main_menu"],
		[exitConfirmationDialog, "popup_hide", self, "_pause_battle"],

		[battle, "wave_started", waveCounter, "set_value"],

		[battle, "base_damaged", player_base, "take_damage"],

		[battle, "material_collected", player_material_storage, "add_material"],
		[self, "material_used", player_material_storage, "use_material"],

		[player_material_storage, "changed", materialList, "reinit", [player_material_storage]]
	])

	SIGNAL.bind_bulk(
		gameOverDialog, self,
		[
			["main_menu_requested", "_on_main_menu_requested"],
			["restart_requested", "_on_battle_restart_requested"],
		]
	)

	SIGNAL.bind_bulk(
		battle, self,
		[
			["unit_selected", "_on_unit_selected"],
			["unit_spawned", "_on_unit_spawned"],
			["wave_completed", "_on_wave_completed"],
		]
	)

	SIGNAL.bind_bulk(
		craftingMenu, self,
		[
			["unit_created", "_on_unit_created"],
			["crafting_cancelled", "_on_crafting_cancelled"]
		]
	)

#	if OS.has_feature("standalone"):
#	_cached_recipes.clear()

#	LOG.pr(LOG.LOG_TYPE.INTERNAL, "UNIT_DATA_POOL:")

	for item in unit_data_pool.get_items():
#		LOG.pr(LOG.LOG_TYPE.INTERNAL, "ITEM: (\n%s\n)" % [item])
		_cached_recipes.append(
			UnitRecipe.new(item)
		)

	_update_recipe_list()
	GROUP.get_global(GROUP.SCENE_MANAGER).scene_loaded()
	AUDIO.play_bgm(AUDIO.BGM.BATTLE)


### PUBLIC FUNCTIONS ###
func is_any_popup_visible() -> bool:
	return UTILS.any([
			craftingPopup.visible,
			exitConfirmationDialog.visible,
			gameOverPopup.visible,
	])


func send_screen_error(screen_pos : Vector2, text : String):
	screenTextCreator.create_error_text(screen_pos, text)
	return self


### PRIVATE FUNCTIONS ###
func _go_to_main_menu() -> void:
	var scene_manager = GROUP.get_global(GROUP.SCENE_MANAGER)
	scene_manager.change_scene(scene_manager.SCENE.MAIN_MENU)


func _update_recipe_list() -> void:
	unitRecipeList.clear()

	for recipe in _cached_recipes:
		assert(recipe is UnitRecipe)
#		LOG.pr(LOG.LOG_TYPE.INTERNAL, "recipe:\n[%s]" % [recipe])

		var new_recipe_view = unitRecipeList.add_recipe_view(recipe)
		SIGNAL.bind(
			new_recipe_view, "recipe_selected",
			self, "_on_recipe_selected",
			[recipe]
		)


func _pause_battle() -> void:
	battle.paused = not battle.paused
	UTILS.pause_node(battle, not battle.paused)


func _get_center():
	return screenTextCreator.get_global_rect().position\
			+ screenTextCreator.get_global_rect().size / 2.0\
			- Vector2(524, 188) / 2.0


### SIGNAL RESPONSES ###
func _on_recipe_selected(unit_recipe : UnitRecipe) -> void:
	assert(unit_recipe)
	LOG.pr(LOG.LOG_TYPE.INPUT,\
		"UNIT_VIEW PRESSED WITH [%s] unit_total[%s]\nstorage[%s]"\
		% [unit_recipe, unit_recipe.total_cost(), player_material_storage])

	if player_material_storage.covers_cost(unit_recipe.total_cost()):
		battle.set_dragged_item(unit_recipe)
	else:
		LOG.pr(LOG.LOG_TYPE.INPUT, "RECIPE CANNOT BE AFFORDED [%s] \n [%s]" % [unit_recipe, unit_recipe.total_cost()])
		send_screen_error(get_global_mouse_position() + Vector2.UP * 40.0, "Not Enough Materials")

func _on_unit_spawned(unit_recipe : UnitRecipe):
	# Spend the material cost of the unit
	var recipe_mat_storage = unit_recipe.total_cost()
	for mat in recipe_mat_storage.get_materials():
		var count = recipe_mat_storage.get_material_count(mat)
		emit_signal("material_used", mat, count)


func _on_unit_selected(unit) -> void:
#	debugWindow.display_unit(unit)
	unitInfoDisplay.init_from_unit(unit)
	unitInfoPopupPanel.popup()

	if not unit.is_connected("info_updated", unitInfoDisplay, "_on_info_updated"):
		SIGNAL.bind(
			unit, "info_updated",
			unitInfoDisplay, "_on_info_updated",
			[unit])


func _on_wave_start_button_pressed() -> void:
	battle.start_next_wave()
	startWaveButton.hide()


func _on_wave_completed(_wave_number) -> void:
	screenTextCreator.create_gratz_text(_get_center(), "Wave %s cleared" % [_wave_number])
	startWaveButton.show()


func _on_player_main_base_destroyed() -> void:
	LOG.pr(LOG.LOG_TYPE.GAMEPLAY, "PLAYER LOST")
	_player_lost = true
	_pause_battle()

	gameOverDialog.set_waves_survived(battle.get_current_wave())
	gameOverPopup.popup()


func _on_CraftButton_pressed() -> void:
	# Display Craft Menu
	craftingMenu.reinit(player_material_storage)
	_pause_battle()
	craftingPopup.popup()


func _on_unit_created(unit_recipe) -> void:
	LOG.pr(LOG.LOG_TYPE.INTERNAL, "UNIT WITH RECIPE CREATED [%s]" % [unit_recipe])
	craftingPopup.hide()
	materialList.reinit(craftingMenu.recover_mat_from_slots().get_storage())
	_pause_battle()
	_cached_recipes.append(unit_recipe)
	_update_recipe_list()


func _on_crafting_cancelled() -> void:
	LOG.pr(LOG.LOG_TYPE.INPUT, "CRAFTING CANCELLED")
	craftingPopup.hide()
	_pause_battle()
	materialList.reinit(craftingMenu.recover_mat_from_slots().get_storage())


func _on_battle_restart_requested() -> void:
	var scene_manager = GROUP.get_global(GROUP.SCENE_MANAGER)
	scene_manager.change_scene(scene_manager.SCENE.GAME_3)
	_pause_battle()



func _on_main_menu_requested() -> void:
	var scene_manager = GROUP.get_global(GROUP.SCENE_MANAGER)
	scene_manager.change_scene(scene_manager.SCENE.MAIN_MENU)
#	_pause_battle()
