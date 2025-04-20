extends Node

@onready var sprite: Sprite2D = $Sprite2D
@onready var animationPlayer := $AnimationPlayer
@export var keyChar : String = "K"
@export var text = ""
@onready var label := $Label # o $Panel/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reemplazar_sprite_atlas(ResourceLoader.load("res://Assets/SimpleKeysSprites/" + keyChar + ".png"))
	animationPlayer.play("click")
	

	# Asignar el texto al Label y habilitar multilinea
	label.text = text
	label.max_lines_visible = 5  # Ajusta el número de líneas visibles si es necesario
	label.position.x = animationPlayer.current_animation_position - label.size.x / 4
	label.position.y = 12  # Ajuste para centrar el texto


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
