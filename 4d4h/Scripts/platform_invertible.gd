extends StaticBody2D

@onready var sprite2D = $Sprite2D
@onready var collisionShape2D := $CollisionShape2D
@onready var pointLight2D := $PointLight2D

@export var when_appers := 0 #0 ambos, 1 normal, 2 invertido
@export var frame := 0

var active := true
var frames:= {
	0: 2,
	1: 3,
	4: 6,
	5: 7,
	8: 10,
	9: 11,
	12: 14,
	13: 15,
	16: 17
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("reacts_to_inversion")
	if frame in frames.values():
		frame = get_key_by_value(frame)
	sprite2D.frame = frame
	active = when_appers != 2
	sprite2D.visible = active
	collisionShape2D.disabled = not active
	pointLight2D.enabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_invert(state: bool):
	active = state == (when_appers == 2) or (when_appers == 0)
	sprite2D.visible = active
	collisionShape2D.disabled = not active
	sprite2D.frame = frames[frame] if state else frame
	pointLight2D.enabled = state and (not when_appers != 1)

func get_key_by_value(value: int) -> int:
	for k in frames.keys():
		if frames[k] == value:
			return k
	return -1
