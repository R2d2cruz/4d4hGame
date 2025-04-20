extends TileMapLayer

# Mapeo entre tiles: cada clave es un par (source_id, atlas_coords), cada valor su contraparte
@export var tile_swap_map := {
	Vector3i(0, 1, 0): Vector3i(3, 1, 0),
	Vector3i(0, 2, 0): Vector3i(3, 2, 0),
	Vector3i(0, 4, 0): Vector3i(3, 4, 0),
	Vector3i(0, 2, 1): Vector3i(3, 2, 1),
	Vector3i(0, 3, 1): Vector3i(3, 3, 1),
	Vector3i(0, 4, 1): Vector3i(3, 4, 1),
	Vector3i(0, 5, 1): Vector3i(3, 5, 1),
	Vector3i(0, 6, 1): Vector3i(3, 6, 1),
	Vector3i(0, 7, 1): Vector3i(3, 7, 1),
	Vector3i(0, 9, 1): Vector3i(3, 9, 1),
	Vector3i(0, 11, 1): Vector3i(3, 11, 1),
	Vector3i(0, 12, 1): Vector3i(3, 12, 1),
	Vector3i(0, 13, 1): Vector3i(3, 13, 1),
	Vector3i(0, 1, 2): Vector3i(3, 1, 2),
	Vector3i(0, 2, 2): Vector3i(3, 2, 2),
	Vector3i(0, 3, 2): Vector3i(3, 3, 2),
	Vector3i(0, 4, 2): Vector3i(3, 4, 2),
	Vector3i(0, 5, 2): Vector3i(3, 5, 2),
	Vector3i(0, 1, 3): Vector3i(3, 1, 3),
	Vector3i(0, 2, 3): Vector3i(3, 2, 3),
	Vector3i(0, 3, 3): Vector3i(3, 3, 3),
	Vector3i(0, 4, 3): Vector3i(3, 4, 3),
	Vector3i(0, 5, 3): Vector3i(3, 5, 3),
	Vector3i(0, 7, 3): Vector3i(3, 7, 3),
	Vector3i(0, 8, 3): Vector3i(3, 8, 3),
	Vector3i(0, 9, 3): Vector3i(3, 9, 3),
	Vector3i(0, 10, 3): Vector3i(3, 10, 3),
	Vector3i(0, 11, 3): Vector3i(3, 11, 3),
	Vector3i(0, 12, 3): Vector3i(3, 12, 3),
	Vector3i(0, 13, 3): Vector3i(3, 13, 3),
	Vector3i(0, 1, 4): Vector3i(3, 1, 4),
	Vector3i(0, 2, 4): Vector3i(3, 2, 4),
	Vector3i(0, 3, 4): Vector3i(3, 3, 4),
	Vector3i(0, 4, 4): Vector3i(3, 4, 4),
	Vector3i(0, 5, 4): Vector3i(3, 5, 4),
	Vector3i(0, 8, 4): Vector3i(3, 8, 4),
	Vector3i(0, 9, 4): Vector3i(3, 9, 4),
	Vector3i(0, 10, 4): Vector3i(3, 10, 4),
	Vector3i(0, 11, 4): Vector3i(3, 11, 4),
	Vector3i(0, 12, 4): Vector3i(3, 12, 4),
	Vector3i(0, 9, 5): Vector3i(3, 9, 5),
	Vector3i(0, 10, 5): Vector3i(3, 10, 5),
	Vector3i(0, 11, 5): Vector3i(3, 11, 5),
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
