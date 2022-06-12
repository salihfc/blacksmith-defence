extends TileMap
class_name BaseTilemap
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
func get_center_of_cell_containing(pos : Vector2) -> Vector2:
	return map_to_world(world_to_map(pos)) + Vector2(cell_size.x, cell_size.y)/2.0
### PRIVATE FUNCTIONS ###
### SIGNAL RESPONSES ###
