extends TileMapLayer

# Mapeo entre tiles: cada clave es un par (source_id, atlas_coords), cada valor su contraparte
@export var tile_swap_map := {
	Vector3i(1, 2, 1): Vector3i(2, 2, 1),  # source 1 (2,1) => source 2 (2,1)
	Vector3i(1, 3, 1): Vector3i(2, 3, 1),  # source 1 (3,1) => source 2 (3,1)
	Vector3i(1, 5, 1): Vector3i(2, 4, 1),  # source 1 (5,1) => source 2 (4,1)
}

func _ready():
	add_to_group("reacts_to_inversion")

func on_invert(state: bool):
	for pos in get_used_cells():
		var current_source := get_cell_source_id(pos)
		var current_coords := get_cell_atlas_coords(pos)
		var key := Vector3i(current_source, current_coords.x, current_coords.y)

		if state:
			# Normal → Invertido
			if tile_swap_map.has(key):
				var new_tile: Vector3i = tile_swap_map[key]
				set_cell(pos, new_tile.x, Vector2i(new_tile.y, new_tile.z))
		else:
			# Invertido → Normal (búsqueda reversa)
			var reverse_key := get_key_by_value(tile_swap_map, key)
			if reverse_key != null:
				set_cell(pos, reverse_key.x, Vector2i(reverse_key.y, reverse_key.z))

func get_key_by_value(dict: Dictionary, value: Vector3i) -> Vector3i:
	for k in dict.keys():
		if dict[k] == value:
			return k
	return value
