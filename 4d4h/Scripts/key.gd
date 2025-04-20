extends Node

@onready var sprite: Sprite2D = $Sprite2D
@onready var animationPlayer := $AnimationPlayer
@onready var light := $PointLight2D
@onready var tileMap := $TileMapLayer
@export var keyChar : String = "K"
@export var text = ""
@onready var label := $CenterContainer/Label # o $Panel/Label

@export var tile_swap_map := {
	Vector3i(0, 3, 0): Vector3i(0, 0, 0),
	Vector3i(0, 3, 1): Vector3i(0, 0, 1),
	Vector3i(0, 3, 2): Vector3i(0, 0, 2),
	Vector3i(0, 4, 0): Vector3i(0, 1, 0),
	Vector3i(0, 4, 1): Vector3i(0, 1, 1),
	Vector3i(0, 4, 2): Vector3i(0, 1, 2),
	Vector3i(0, 5, 0): Vector3i(0, 2, 0),
	Vector3i(0, 5, 1): Vector3i(0, 2, 1),
	Vector3i(0, 5, 2): Vector3i(0, 2, 2),
	
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("reacts_to_inversion")
	reemplazar_sprite_atlas(ResourceLoader.load("res://Assets/SimpleKeysSprites/" + keyChar + ".png"))
	animationPlayer.play("click")
	light.enabled = false
	

	# Asignar el texto al Label y habilitar multilinea
	var texto_con_saltos = text.replace("\\n", "\n")
	label.text = texto_con_saltos
	await get_tree().process_frame
	label.max_lines_visible = 5 # Ajusta el número de líneas visibles si es necesario
	#label.position.x = - label.size.x/2
	#label.position.y = 12  # Ajuste para centrar el texto
	
func on_invert(state: bool):
	light.enabled = state
	label.modulate = Color.BLACK if state else Color.WHITE
	for pos in tileMap.get_used_cells():
		var current_source : int = tileMap.get_cell_source_id(pos)
		var current_coords : Vector2i = tileMap.get_cell_atlas_coords(pos)
		var key := Vector3i(current_source, current_coords.x, current_coords.y)

		if state:
			# Normal → Invertido
			if tile_swap_map.has(key):
				var new_tile: Vector3i = tile_swap_map[key]
				tileMap.set_cell(pos, new_tile.x, Vector2i(new_tile.y, new_tile.z))
		else:
			# Invertido → Normal (búsqueda reversa)
			var reverse_key := get_key_by_value(tile_swap_map, key)
			if reverse_key != null:
				tileMap.set_cell(pos, reverse_key.x, Vector2i(reverse_key.y, reverse_key.z))

func get_key_by_value(dict: Dictionary, value: Vector3i) -> Vector3i:
	for k in dict.keys():
		if dict[k] == value:
			return k
	return value
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reemplazar_sprite_atlas(nueva_textura: Texture2D) -> void:
	# Guardar los parámetros actuales
	var frame_actual = sprite.frame
	var hframes_actual = sprite.hframes
	var vframes_actual = sprite.vframes
	var region_enabled = sprite.region_enabled
	var region_rect = sprite.region_rect
	var flip_h = sprite.flip_h
	var flip_v = sprite.flip_v
	
	# Asignar la nueva textura
	sprite.texture = nueva_textura
	
	# Restaurar los parámetros
	sprite.hframes = hframes_actual
	sprite.vframes = vframes_actual
	sprite.frame = frame_actual
	sprite.region_enabled = region_enabled
	sprite.region_rect = region_rect
	sprite.flip_h = flip_h
	sprite.flip_v = flip_v
