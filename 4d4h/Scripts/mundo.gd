extends Node2D

@onready var directionalLight := $DirectionalLight2D
@onready var backGround : = $Background

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	directionalLight.enabled = false
	
func on_invert(state: bool):
	directionalLight.enabled = state
	backGround.color = Color8(48, 48, 48) if state else Color8(180, 180, 180)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
