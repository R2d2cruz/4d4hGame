extends StaticBody2D

@onready var sprite2D = $Sprite2D
@onready var collisionShape2D := $CollisionShape2D
@export var appears_when_inverted := false
@export var frame := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("reacts_to_inversion")
	sprite2D.frame = frame
	sprite2D.visible = !appears_when_inverted

# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_invert(state: bool):
	visible = state == appears_when_inverted
	collisionShape2D.disabled = not visible
	sprite2D.visible = visible

func get_key_by_value(dict: Dictionary, value: int) -> int:
	for k in dict.keys():
		if dict[k] == value:
			return k
	return -1
